//
//  FoodItem.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//
import Foundation

struct FoodItem: Identifiable {
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

enum FoodLocation: String, Codable, CaseIterable {
    case pantry = "Pantry"
    case fridge = "Fridge"
    case freezer = "Freezer"
}
