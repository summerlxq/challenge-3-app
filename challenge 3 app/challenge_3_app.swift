//
//  challenge_3_app.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI
import SwiftData

@main
struct challenge_3_app: App {
    @State private var inventory = FoodInventoryView()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(inventory)
        }
        .modelContainer(for:FoodItem.self)
    }
}
