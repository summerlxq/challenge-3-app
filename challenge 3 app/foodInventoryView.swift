//
//  FoodInventoryView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import Foundation
import SwiftUI
internal import Combine

class foodInventoryView: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    
    init() {
        foodItems = [
            FoodItem(nameOfFood: "bred", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(4*24*60*60)),
            FoodItem(nameOfFood: "tequila", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(4*24*60*60)),
            FoodItem(nameOfFood: "seaweed", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(4*24*60*60)),
            FoodItem(nameOfFood: "syrup", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(4*24*60*60)),
            FoodItem(nameOfFood: "buldak", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(2*24*60*60)),
            FoodItem(nameOfFood: "guava", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(-3*24*60*60)),
            FoodItem(nameOfFood: "cheesewheel", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(-5*24*60*60)),
            FoodItem(nameOfFood: "you", dateScanned: Date(), dateExpiring: Date().addingTimeInterval(-10*24*60*60))
        ]
    }
}
