//
//  challenge_3_appApp.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI

@main
struct challenge_3_appApp: App {
    @StateObject private var inventory = FoodInventoryView
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(inventory)
        }
    }
}
