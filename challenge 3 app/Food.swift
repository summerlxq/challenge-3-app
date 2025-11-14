//
//  FoodItem.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let nameOfFood: String
    let dateScanned: Date
    let dateExpiring: Date
    let quantity: Int = 1
    
    var daysUntilExpiration: Int {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dateExpiring).day ?? 0
        return days
    }
}
