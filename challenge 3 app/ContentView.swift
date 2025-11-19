//
//  ContentView.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI
import SwiftData
import FoundationModels

@Generable
enum Foodtype: String, CaseIterable, Identifiable, Codable {
    case all, pantry, fridge, freezer
    var id: Self { self }
}
// enum for picker selection

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var foodItems: [FoodItem]
    
    @State private var selectedItem: FoodItem?
    //select each item from FoodItem
    
    @State private var selectedType: Foodtype = .all
    // selects from Foodtype (location)
    
    
    @State private var searchText = ""
    
    //    @State private var allFoodItems: [FoodItem] = [
    //        FoodItem(nameOfFood: "lettuce", dateScanned: Date(), dateExpiring: Date(), storageLocation: .fridge),
    //        FoodItem(nameOfFood: "biscuits", dateScanned: Date(), dateExpiring: Date(), storageLocation: .pantry),
    //        FoodItem(nameOfFood: "cactus", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 3))!, storageLocation: .pantry),
    //        FoodItem(nameOfFood: "ice cream", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 27))!, storageLocation: .freezer)
    //    ] // subjects all food items to custom data type FoodItem
    
    @State private var isInfoShown = false
    // modal sheet boolean
    
    
    var numOfExpiring: Int {
        var expiringCount = 0
        for item in foodItems {
            if item.daysUntilExpiration >= 0 && item.daysUntilExpiration <= 5 {
                expiringCount += 1
            }
        }
        return expiringCount
    }
    
    var numOfExpired: Int {
        var expiredCount = 0
        for item in foodItems {
            if item.daysUntilExpiration < 0 {
                expiredCount += 1
            }
        }
        return expiredCount
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        ExpiringView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.yellow)
                            Text("\(numOfExpiring) \n Expiring...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                        .frame(maxWidth: .infinity) // takes up as much space as it can
                        .aspectRatio(1.5, contentMode: .fit) // ratio of width to height
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    Spacer()
                    NavigationLink {
                        ExpiredView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.red)
                            Text("\(numOfExpired) \n Expired...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                        .frame(maxWidth: .infinity) // takes up as much space as it can
                        .aspectRatio(1.5, contentMode: .fit) // ratio of width to height
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding()
                List { // creates a continuous list of items
                    Picker("Foodtype", selection: $selectedType) {
                        // selection of picker from Foodtype
                        Text("all").tag(Foodtype.all)
                        Text("pantry").tag(Foodtype.pantry)
                        Text("fridge").tag(Foodtype.fridge)
                        Text("freezer").tag(Foodtype.freezer)
                    }
                    .pickerStyle(.segmented)
                    
                    Section("expired") {
                        // separates picker from items below
                        ForEach(foodItems) { item in
                            if item.daysUntilExpiration < 0 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
                                }
                                .swipeActions {
                                    Button("Delete") {
                                        modelContext.delete(item)
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                    Section("this week") {
                        ForEach(foodItems) { item in
                            if item.daysUntilExpiration < 7 && item.daysUntilExpiration >= 0 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
                                }
                                .swipeActions {
                                    Button("Delete") {
                                        modelContext.delete(item)
                                    }
                                    .tint(.red)
                                }
                            }
                            
                        }
                    }
                    Section("next week") {
                        ForEach(foodItems) { item in
                            if item.daysUntilExpiration > 7 && item.daysUntilExpiration <= 14 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
                                }
                                .swipeActions {
                                    Button("Delete") {
                                        modelContext.delete(item)
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                    Section("future") {
                        ForEach(foodItems) { item in
                            if item.daysUntilExpiration > 14 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
                                }
                                .swipeActions {
                                    Button("Delete") {
                                        modelContext.delete(item)
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                }
                .sheet(item: $selectedItem) { item in
                    VStack {
                        Text("\(item.nameOfFood)")
                            .font(.largeTitle)
                        Text("Date scanned: \(item.dateScanned.formatted(date: .abbreviated, time: .omitted))")
                        Text("Date expiring: \(item.dateExpiring.formatted(date: .abbreviated, time: .omitted))")
                        Text("Days to expiry: \(item.daysUntilExpiration)")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: ScanView()) {
                        Text("+")
                    }
                    .font(.largeTitle)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    ContentView()
        .modelContainer(for:FoodItem.self)
}
