//
//  ExpiringView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI
import SwiftData

struct ExpiringView: View {    
    var numOfExpiring: Int {
        var expiringCount = 0
        for item in foodItems {
            if item.daysUntilExpiration >= 0 && item.daysUntilExpiration <= 5 {
                expiringCount += 1
            }
        }
        return expiringCount
    }
    
    @Query var foodItems: [FoodItem]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(foodItems) { item in
                    if item.daysUntilExpiration >= 0 && item.daysUntilExpiration <= 5 {
                        HStack {
                            Text(item.nameOfFood)
                            Spacer()
                            Text("\(item.daysUntilExpiration) days")
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Expiring")
        }
    }
}

#Preview {
    ExpiringView()
}
