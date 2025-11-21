//
//  ExpiredView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI
import SwiftData

struct ExpiredView: View {    
    var numOfExpired: Int {
        var expiredCount = 0
        for item in foodItems {
            if item.daysUntilExpiration < 0 {
                expiredCount += 1
            }
        }
        return expiredCount
    }
    
    var sortedExpiredItems: [FoodItem] {
        foodItems
            .filter { $0.daysUntilExpiration < 0 }
            .sorted { $0.daysUntilExpiration > $1.daysUntilExpiration }
    }
    
    @Query var foodItems: [FoodItem]
    
    var body: some View {
        VStack {
            if foodItems.filter({ item in
                item.daysUntilExpiration < 0
            }).count == 0 {
                ContentUnavailableView("No Expired Foods", systemImage: "calendar")
            } else {
                ScrollView {
                    VStack {
                        ForEach(foodItems.filter { item in
                            item.daysUntilExpiration < 0
                        }) { item in
                            HStack {
                                Text(item.nameOfFood)
                                Spacer()
                                Text("\(abs(item.daysUntilExpiration)) days ago")
                            }
                            .padding()
                            .background(Color.red.opacity(0.3))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationTitle("Expired")
    }
}

#Preview {
    ExpiredView()
}
