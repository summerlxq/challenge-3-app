//
//  ExpiredView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI

struct ExpiredView: View {
    @Environment(foodInventoryView.self) var viewModel
    
    var numOfExpired: Int {
        var expiredCount = 0
        for item in viewModel.foodItems {
            if item.daysUntilExpiration < 0 {
                expiredCount += 1
            }
        }
        return expiredCount
    }
    
    var sortedExpiredItems: [FoodItem] {
        viewModel.foodItems
            .filter { $0.daysUntilExpiration < 0 }
            .sorted { $0.daysUntilExpiration > $1.daysUntilExpiration }
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text("EXPIRED")
                    .font(.largeTitle)
                
                ForEach(viewModel.foodItems) { item in
                    if item.daysUntilExpiration < 0 {
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
}

#Preview {
    ExpiredView()
}
