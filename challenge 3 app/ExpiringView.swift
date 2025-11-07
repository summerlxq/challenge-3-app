//
//  ExpiringView.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 7/11/25.
//

import SwiftUI

struct ExpiringView: View {
    @EnvironmentObject var inventoryVM: FoodInventoryViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("EXPIRING SOON")
                .font(.system(size: 35, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

#Preview {
    ExpiringView()
}
