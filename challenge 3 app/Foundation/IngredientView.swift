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
    
    @Binding var foods: [FoodItem]
    
    var body: some View{
        
        @Bindable var viewModel = viewModel
        
        NavigationStack{
                VStack{
                    List{
                        if viewModel.foods.isEmpty {
                            ContentUnavailableView("No Food Items", systemImage: "fork.knife")
                        } else {
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
                        .onSubmit {
                            viewModel.addFood(name: "")
                            Task {
                                try? await Task.sleep(for: .milliseconds(10))
                                isNewFieldFocused = true
                            }
                        }
                    }
                    
                    //                if showNewField {
                    //                    TextField("New item", text: $newItem)
                    //                }
                }
                .navigationTitle("Confirm List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            viewModel.addFood(name: "")
                            //                        showNewField = true
                            
                            Task {
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
                                    if !food.name.isEmpty {
                                        let foodPlace = await FoodLocation.getStorageLocation(for: food.name)
                                        let myFoodItem = await FoodLocation.predictExpiry(foodName: food.name, foodType: foodPlace)
                                        foods.append(myFoodItem)
                                        //                                modelContext.insert(myFoodItem)
                                        //                                dismiss()
                                    }
                                }
                                isLoading = false
                                isShown = true
                            }
                            
                        } label: {
                            if isLoading{
                                ProgressView()
                                
                            }else{
                                Text("Next")
                            }
                            
                        }
                        .disabled(viewModel.foods.isEmpty)
                    }
                }
                .navigationDestination(isPresented: $isShown) {
                    ConfirmationView(foodItems: $foods, navigate: $navigate)
                }
            }
            
        }
    }
}

