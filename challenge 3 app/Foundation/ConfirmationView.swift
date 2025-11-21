//
//  ConfirmationView.swift
//  challenge 3 app
//
//  Created by Ella Teo on 15/11/25.
//

import SwiftUI
import SwiftData

struct ConfirmationView: View {
    @Binding var foodItems: [FoodItem]
    @Environment(VisionModel.self) var viewModel
    @Environment(\.modelContext) var modelContext
    @Binding var navigate: Bool
//    @Binding var showIngredientView: Bool

    var body: some View {
        List{
            ForEach($foodItems){ item in
                NavigationLink(destination: EditDetailsView(item: item)){
                        VStack(alignment: .leading) {
                            Text(item.nameOfFood.wrappedValue)
                                .fontWeight(.bold)
                                .font(.headline)
                            Text("\(item.dateExpiring.wrappedValue.formatted(date: .abbreviated, time: .omitted))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(item.storageLocation.wrappedValue.rawValue.capitalized)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    for food in foodItems{
                        modelContext.insert(food)
                    }
                    foodItems = []
                    viewModel.foods = []
                    navigate = false
//                    showIngredientView = false
                }label: {
                    Text("Save")
                }
                .disabled(foodItems.isEmpty)
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Edit Details")
    }
}


