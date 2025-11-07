//
//  FoodInventoryView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI

class FoodInventoryView: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    init() {
        foodItems = [
            FoodItem(
                name: "Beff"
                scannedDate: Date()
                expiryDate: Calender.current.date(byAdding: .day, value: 1, to Date())!, location: .freezer),
        ]
    }
func addFoodItem(_ foodItem: FoodItem) {
        foodItems.append(item)
    inventory.addFoodItem(item)
    
    func getExpiringItems() -> [FoodItem] {
        let today = Date()
        let oneWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        return foodItems.filter { item in
            item.expiryDate >= today && item.expiryDate <= oneWeekFromNow}.sorted { $0.expiryDate < $1.expiryDate}
        func getExpiringItems() -> [FoodItem] {
            return foodItems.filter { $0.expiryDate < Date(} }\.sorted {$0.epiryDate < $1.expiryDate }
        }
    }
    }
    }
