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
            FoodItem(nameOfFood: "bread", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(7*24*60*60)),
            FoodItem(nameOfFood: "tequila", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(365*24*60*60)),
            FoodItem(nameOfFood: "seaweed", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(30*24*60*60)),
            FoodItem(nameOfFood: "syrup", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(180*24*60*60)),
            FoodItem(nameOfFood: "buldak", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(90*24*60*60)),
            FoodItem(nameOfFood: "guava", dateScanned: Date().addingTimeInterval(-7*24*60*60), dateExpiring: Date().addingTimeInterval(-3*24*60*60)),
            FoodItem(nameOfFood: "cheesewheel", dateScanned: Date().addingTimeInterval(-10*24*60*60), dateExpiring: Date().addingTimeInterval(-5*24*60*60)),
            FoodItem(nameOfFood: "lotus root", dateScanned: Date().addingTimeInterval(-15*24*60*60), dateExpiring: Date().addingTimeInterval(-10*24*60*60))
        ]
    }
}
