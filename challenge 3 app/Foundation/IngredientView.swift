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
//    @Binding var showIngredientView: Bool
    
    @State private var showNewField = false
    @FocusState private var isNewFieldFocused: Bool
    
    @State private var foods: [FoodItem] = []
    
    var body: some View{
        
        @Bindable var viewModel = viewModel
        
        NavigationStack{
            VStack{
                Text("No food item available.")
                List{
                    ForEach($viewModel.foods){ $food in
                        TextField("Name", text: $food.name, onCommit: {
                            isNewFieldFocused = false
                        })
                    }
                    .onDelete{ indexSet in
                        viewModel.deleteFoods(at: indexSet)
                    }
                    .onMove{ indices, newOffset in
                        viewModel.moveFoods(from: indices, to: newOffset)
                    }
                    .focused($isNewFieldFocused)
                }
                
//                if showNewField {
//                    TextField("New item", text: $newItem)
//                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 3)
            .navigationTitle("Confirm List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        viewModel.addFood(name: "")
                        showNewField = true
                        
                        DispatchQueue.main.async {
                            isNewFieldFocused = true
                        }
                    }label:{
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add item to list")
                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        print("Hello")
                        isLoading = true
                        Task{
                            for food in viewModel.foods{
                                let foodPlace = await FoodLocation.getStorageLocation(for: food.name)
                                let myFoodItem = await FoodLocation.predictExpiry(foodName: food.name, foodType: foodPlace)
                                foods.append(myFoodItem)
//                                modelContext.insert(myFoodItem)
//                                dismiss()
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

