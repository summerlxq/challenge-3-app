//
//  BindableEditDetails.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 19/11/25.
//
import SwiftUI
import SwiftData

struct BindableEditDetailsView: View {
    @Bindable var item: FoodItem
    var body: some View {
        List{
            TextField("Name",text: $item.nameOfFood)
            DatePicker("Date Scanned",selection: $item.dateScanned, displayedComponents: .date)
            DatePicker("Expiry Date",selection: $item.dateExpiring, displayedComponents: .date)
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
        .navigationTitle(item.nameOfFood)
    }
}

