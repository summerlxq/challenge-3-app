//
//  ExpiringView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI

struct ExpiringView: View {
    @EnvironmentObject var viewModel: foodInventoryView
    
    var body: some View {
        ScrollView {
            VStack {
                Text("EXPIRING SOON")
                    .font(.largeTitle)
                
                ForEach(viewModel.foodItems) { item in
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
        }
    }
}

#Preview {
    ExpiringView()
        .environmentObject(foodInventoryView())
}
