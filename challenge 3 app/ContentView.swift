//
//  ContentView.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI

enum Foodtype: String, CaseIterable, Identifiable {
    case all, pantry, fridge, freezer
    var id: Self { self }
}
// enum for picker selection

struct ContentView: View {
    
    @State private var selectedType: Foodtype = .all
    // variable of picker
    
    @State private var searchText = ""
    
    @State private var allFoodItems: [FoodItem] = [
        FoodItem(nameOfFood: "lettuce", dateScanned: Date(), dateExpiring: Date(), storageLocation: .fridge),
        FoodItem(nameOfFood: "biscuits", dateScanned: Date(), dateExpiring: Date(), storageLocation: .pantry),
        FoodItem(nameOfFood: "cactus", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 3))!, storageLocation: .pantry),
        FoodItem(nameOfFood: "ice cream", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 27))!, storageLocation: .freezer)
    ] // subjects all food items to custom data type FoodItem
    
    @State private var isInfoShown = false
    // default modal sheet information
    
    @State private var selectedItem: FoodItem?
    
    @State var numExpiring = 0 // number of expiring foods
    @State var numExpired = 0 // number of expired foods
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        ExpiringView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.red)
                            Text("\(numExpiring) \n Expiring...")
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
                                .fill(Color.yellow)
                            Text("\(numExpired) \n Expired...")
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
                        ForEach(allFoodItems) { item in
                            if item.daysUntilExpiration < 0 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
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
                        }
                    }
                    Section("this week") {
                        ForEach(allFoodItems) { item in
                            if item.daysUntilExpiration < 7 && item.daysUntilExpiration >= 0 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
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
                        }
                    }
                    Section("next week") {
                        ForEach(allFoodItems) { item in
                            if item.daysUntilExpiration > 7 && item.daysUntilExpiration <= 14 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
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
                        }
                    }
                    Section("later") {
                        ForEach(allFoodItems) { item in
                            if item.daysUntilExpiration > 14 && (item.storageLocation == selectedType || selectedType == .all) {
                                Button("\(item.nameOfFood)") {
                                    selectedItem = item
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
                        }
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
}

