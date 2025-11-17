//
//  challenge_3_appApp.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI
import SwiftData

@main
struct challenge_3_appApp: App {
    @State private var inventory = foodInventoryView()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(inventory)
        }
        .modelContainer(for:FoodItem.self)
    }
}
