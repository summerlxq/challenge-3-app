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

struct FoodItem: Identifiable{
    var id = UUID()
    var nameOfFood: String
    var dateScanned: Date
    var dateExpiring: Date
    var daysToExpiry: Int {
        let fromDate = Calendar.current.startOfDay(for: Date())
        let toDate = Calendar.current.startOfDay(for: dateExpiring)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
struct ContentView: View {
    
    @State private var selectedType: Foodtype = .all
    
    @State private var searchText = ""
    
    @State private var allFoodItems: [FoodItem] = [FoodItem(nameOfFood: "lettuce", dateScanned: Date(), dateExpiring: Date())]
    
    @State private var isInfoShown = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink ("Expiring") {
                        ExpiringView()
                    }
                    NavigationLink("Expired") {
                        ExpiredView()
                    }
                }
                
                List {
                    Picker("Foodtype", selection: $selectedType) {
                        Text("all").tag(Foodtype.all)
                        Text("pantry").tag(Foodtype.pantry)
                        Text("fridge").tag(Foodtype.fridge)
                        Text("freezer").tag(Foodtype.freezer)
                    }
                    .pickerStyle(.segmented)
                    
                    Section {
                        ForEach(allFoodItems) { allFoodItem in
                            Button("\(allFoodItem.nameOfFood)") {
                                isInfoShown = true
                            }
                            .sheet(isPresented: $isInfoShown) {
                                VStack {
                                    Text("\(allFoodItem.nameOfFood)")
                                        .font(.largeTitle)
                                    Text("Date scanned: \(allFoodItem.dateExpiring)")
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
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    ContentView()
}
