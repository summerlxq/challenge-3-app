//
//  ExpiredView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

    import SwiftUI

    struct ExpiredView: View {
        @EnvironmentObject var viewModel: foodInventoryView
        
        var sortedExpiredItems: [FoodItem] {
            viewModel.foodItems
                .filter { $0.daysUntilExpiration < 0 }
                .sorted { $0.daysUntilExpiration > $1.daysUntilExpiration }
        }
        
        var body: some View {
            ScrollView {
                VStack {
                    Text("EXPIRED")
                        .font(.largeTitle)
                    
                    ForEach(sortedExpiredItems) { item in
                        HStack {
                            Text(item.nameOfFood)
                            Spacer()
                            Text("\(abs(item.daysUntilExpiration)) days ago")
                        }
                        .padding()
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }

    #Preview {
        ExpiredView()
            .environmentObject(foodInventoryView())
    }
