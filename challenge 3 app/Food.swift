//
//  FoodItem.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//
import SwiftUI
import Foundation

// custom data type FoodItem to store information
struct FoodItem: Identifiable {
    let id = UUID()
    let nameOfFood: String
    let dateScanned: Date
    let dateExpiring: Date
    let quantity: Int = 1
    let storageLocation: Foodtype // enum Foodtype for a limited selection
    
    var daysUntilExpiration: Int {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dateExpiring).day ?? 0
        // calculate number of days to expiry
        return days
    }
}
