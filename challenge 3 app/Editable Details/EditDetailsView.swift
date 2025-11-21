//
//  EditDetailsView.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 19/11/25.
//

import SwiftUI
import SwiftData

struct EditDetailsView: View {
    @Binding var item: FoodItem
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Form{
            Section("Name"){
                TextField("Name",text: $item.nameOfFood)
            }
            Section("Dates"){
                DatePicker("Date Scanned", selection: $item.dateScanned, displayedComponents: .date)
                DatePicker("Expiry Date", selection: $item.dateExpiring, displayedComponents: .date)

            }
            Section("Storage"){
                Picker("Storage Location", selection: $item.storageLocation) {
                    
                    Text("Pantry")
                        .tag(
                            Foodtype.pantry
                        )
                    Text("Fridge")
                        .tag(
                            Foodtype.fridge
                        )
                    Text("Freezer")
                        .tag(
                            Foodtype.freezer
                        )
                }
            }
            
        }
        .navigationTitle("Edit Details")
    }
}

