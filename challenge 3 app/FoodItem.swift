//
//  FoodItem.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//
import Foundation

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var scannedDate: Date
    var expiryDate: Date
    var location: FoodLocation
}

enum FoodLocation: String, Codable, CaseIterable {
    case pantry = "Pantry"
    case fridge = "Fridge"
    case freezer = "Freezer"
}
