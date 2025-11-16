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

struct ContentView: View {
    
    @EnvironmentObject var viewModel: foodInventoryView
    
    @State private var selectedType: Foodtype = .all
    
    @State private var searchText = ""
    
    @State private var isInfoShown = false
    
    @State private var selectedItem: FoodItem?
    
    @State private var isExpiringShown = false
    
    var numExpiring: Int {
        viewModel.foodItems.filter { $0.daysUntilExpiration >= 0 && $0.daysUntilExpiration <= 5 }.count
    }
    var numExpired: Int {
        viewModel.foodItems.filter { $0.daysUntilExpiration < 0 }.count
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
                            Text("\(numExpiring) \n Expiring...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.5, contentMode: .fit)
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    Spacer()
                    NavigationLink {
                        ExpiredView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.red)
                            Text("\(numExpired) \n Expired...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.5, contentMode: .fit)
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding()
                List {
                    Picker("Foodtype", selection: $selectedType) {
                        Text("all").tag(Foodtype.all)
                        Text("pantry").tag(Foodtype.pantry)
                        Text("fridge").tag(Foodtype.fridge)
                        Text("freezer").tag(Foodtype.freezer)
                    }
                    .pickerStyle(.segmented)
                    
                    Section("expired") {
                        ForEach(viewModel.foodItems) { item in
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
                        ForEach(viewModel.foodItems) { item in
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
                        ForEach(viewModel.foodItems) { item in
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
                    Section("future") {
                        ForEach(viewModel.foodItems) { item in
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
        .environmentObject(foodInventoryView())
}
