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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FoodItem.self)
    }
}
