//
//  ContentView.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 5/11/25.
//

import SwiftUI
import SwiftData

import PhotosUI
import Vision
import VisionKit
import FoundationModels

@Generable
enum Foodtype: String, CaseIterable, Identifiable, Codable {
    case all, pantry, fridge, freezer
    var id: Self { self }
}
// enum for picker selection

struct ContentView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            HomeView(searchText: searchText)
            
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    ContentView()
        .modelContainer(for:FoodItem.self)
}
