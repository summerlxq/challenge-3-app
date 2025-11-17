//
//  SwiftUIView.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 15/11/25.
//

import SwiftUI
import FoundationModels

struct SwiftUIView: View {
    @State var viewModel = foodInventoryView()
    @State private var isProcessing = false
    
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    var body: some View {
        VStack {
            if isProcessing {
                ProgressView("predicting...")
                    .padding()
            } else {
                Button("predict") {
                    Task {
                        isProcessing = true
                        await predictAllExpirations()
                        isProcessing = false
                    }
                }
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.foodItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.nameOfFood)
                                .font(.headline)
                            Text("location: \(item.storageLocation)")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("bought: \(item.dateScanned.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("expires: \(item.dateExpiring.formatted(date: .abbreviated, time: .omitted))")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func predictAllExpirations() async {
        if isPreview {
            print("Preview detected — skipping LanguageModelSession to avoid preview crash")
            return
        }
        
        let session = LanguageModelSession()
        
        for item in viewModel.foodItems {
            do {
                let prompt = """
You are a food safety expert. Predict the expiration date for the following food item with high accuracy.

Food Item: \(item.nameOfFood)
Purchase Date: \(item.dateScanned.formatted(date: .abbreviated, time: .omitted))
Storage Location: \(item.storageLocation)

Instructions:
- Use USDA guidelines and standard food safety data
- Consider typical shelf life for \(item.nameOfFood) stored in \(item.storageLocation)
- Account for the purchase date
- The expiration date MUST be AFTER the purchase date
- Be realistic and accurate based on real-world food storage times
- For unopened items in proper storage conditions

Provide the predicted expiration date.
"""
                
                let response = try await session.respond(to: prompt, generating: Prediction.self)
                let prediction = response.content
                
                if let index = viewModel.foodItems.firstIndex(where: { $0.id == item.id }) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let expiryDate = dateFormatter.date(from: prediction.expiryDate),
                       expiryDate > item.dateScanned {
                        viewModel.foodItems[index] = FoodItem(
                            nameOfFood: item.nameOfFood,
                            dateScanned: item.dateScanned,
                            dateExpiring: expiryDate, storageLocation: .freezer
                        )
                    }
                }
                
                try await Task.sleep(nanoseconds: 500_000_000)
                
            } catch {
                print("Error predicting for \(item.nameOfFood): \(error)")
            }
        }
    }
}

@Generable
struct Prediction {
    @Guide(description: "The name of the food item")
    var name: String
    
    @Guide(description: "The predicted expiration date in YYYY-MM-DD format based on USDA guidelines and standard shelf life for this specific food in the given storage location")
    var expiryDate: String
    
    @Guide(description: "The date the food was purchased in YYYY-MM-DD format")
    var dateBought: String
    
    @Guide(description: "The storage location where the food is kept (Fridge, Freezer, or Pantry)")
    var location: String
}

#Preview {
    SwiftUIView()
}
