//
//  IngredientView.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 19/11/25.
//
import SwiftUI
import SwiftData

struct IngredientView: View{
    @Environment(VisionModel.self) var viewModel
    @Environment(\.modelContext) var modelContext
    @State var is_active = false
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @State private var isShown = false
    @Binding var navigate: Bool
    
    @State private var foods: [FoodItem] = []
    var body: some View{
        
        @Bindable var viewModel = viewModel
        NavigationStack{
            VStack{
                Text("Edit the names of the foods and delete non-food items")
                List{
                    ForEach($viewModel.foods){ $food in
                        TextField("Name", text: $food.name)
                    }
                    .onDelete{ indexSet in
                        viewModel.deleteFoods(at: indexSet)
                    }
                    .onMove{ indices, newOffset in
                        viewModel.moveFoods(from: indices, to: newOffset)
                    }
                    
                }
            }
            .padding(.vertical, 8)
            .navigationTitle("Confirm Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        viewModel.addFood(name: "New Food")
                    }label:{
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add ingredient")
                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        print("Hello")
                        isLoading = true
                        Task{
                            for food in viewModel.foods{
                                let food_place = await FoodLocation.getStorageLocation(for: food.name)
                                let myfooditem = await FoodLocation.predictExpiry(foodName: food.name, foodType: food_place)
                                foods.append(myfooditem)
                                //modelContext.insert(myfooditem)
                                //dismiss()
                            }
                            isLoading = false
                            isShown = true
                        }
                        
                    }label:{
                        if isLoading{
                            ProgressView()
                            
                        }else{
                            Text("Next")
                        }
                        
                    }
                }
            }
            .navigationDestination(isPresented: $isShown) {
                ConfirmationView(foodItems: $foods, navigate: $navigate)
            }
        }
        
    }
}
