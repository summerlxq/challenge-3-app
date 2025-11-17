//
//  FoodItem.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//
import SwiftUI
import Foundation
import SwiftData

// custom data type FoodItem to store information
@Model
class FoodItem: Identifiable, Equatable {
    var id = UUID()
    var nameOfFood: String
    var dateScanned: Date
    var dateExpiring: Date
    var quantity: Int = 1
    var storageLocation: Foodtype // enum Foodtype for a limited selection
    var isDeleted: Bool = false
    
    var daysUntilExpiration: Int {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dateExpiring).day ?? 0
        return days
    }
    
    init(
        id: UUID = UUID(),
        nameOfFood: String = "",
        dateScanned: Date = Date(),
        dateExpiring: Date,
        quantity: Int = 1,
        storageLocation: Foodtype,
        isDeleted: Bool = false,
    ) {
        self.id = id
        self.nameOfFood = nameOfFood
        self.dateScanned = dateScanned
        self.dateExpiring = dateExpiring
        self.quantity = quantity
        self.storageLocation = storageLocation
        self.isDeleted = isDeleted
    }
}
