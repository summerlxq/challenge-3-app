//
//  FoodInventoryView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

    import Foundation
    import Combine
    import SwiftUI

    class foodInventoryView: ObservableObject {
        @Published var foodItems: [FoodItem] = []
        
        init() {
            foodItems = [
                FoodItem(nameOfFood: "lettuce", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(3*24*60*60), storageLocation: .fridge),
                FoodItem(nameOfFood: "biscuits", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(10*24*60*60), storageLocation: .pantry),
                FoodItem(nameOfFood: "cactus", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 3))!, storageLocation: .pantry),
                FoodItem(nameOfFood: "ice cream", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 27))!, storageLocation: .freezer),
                FoodItem(nameOfFood: "bread", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(3*24*60*60), storageLocation: .freezer),
                FoodItem(nameOfFood: "tequila", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(365*24*60*60), storageLocation: .pantry),
                FoodItem(nameOfFood: "seaweed", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(30*24*60*60), storageLocation: .pantry),
                FoodItem(nameOfFood: "syrup", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(180*24*60*60), storageLocation: .pantry),
                FoodItem(nameOfFood: "buldak", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(90*24*60*60), storageLocation: .pantry),
                FoodItem(nameOfFood: "guava", dateScanned: Date().addingTimeInterval(-7*24*60*60), dateExpiring: Date().addingTimeInterval(-3*24*60*60), storageLocation: .fridge),
                FoodItem(nameOfFood: "cheesewheel", dateScanned: Date().addingTimeInterval(-10*24*60*60), dateExpiring: Date().addingTimeInterval(-5*24*60*60), storageLocation: .fridge),
                FoodItem(nameOfFood: "lotus root", dateScanned: Date().addingTimeInterval(-15*24*60*60), dateExpiring: Date().addingTimeInterval(-10*24*60*60), storageLocation: .fridge)
            ]
        }
    }
