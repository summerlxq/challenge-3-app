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
    @Environment(\.modelContext) var modelContext
    @Binding var navigate: Bool
//    @Binding var showIngredientView: Bool

    var body: some View {
        List{
            ForEach($foodItems){ item in
                NavigationLink(destination: EditDetailsView(item: item)){
                    Text(item.nameOfFood.wrappedValue)
                }
        
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    for food in foodItems{
                        modelContext.insert(food)
                    }
                    navigate = false
//                    showIngredientView = false
                }label: {
                    Text("Save")
                }
                
            }
        }
    }
}


