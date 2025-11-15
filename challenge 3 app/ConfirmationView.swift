//
//  ConfirmationView.swift
//  challenge 3 app
//
//  Created by Ella Teo on 15/11/25.
//

import SwiftUI

struct ConfirmationView: View {
    @State private var buttonText = "Food"
    @State private var isEditing = false
    @State private var newText = ""
    @State private var buttonText2 = "Expiry date"
    @State private var isEditing2 = false
    @State private var newText2 = ""
    
    var body: some View {
        VStack {
            Text("__Title__")
                .font(.largeTitle)
            HStack{
                Menu {
                    Button("Edit") {
                        newText = buttonText
                        isEditing = true
                    }
                } label: {
                    Text(buttonText)
                        .padding()
                        .font(.title2)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
                Menu {
                    Button("Edit") {
                        newText2 = buttonText2
                        isEditing2 = true
                    }
                } label: {
                    Text(buttonText2)
                        .padding()
                        .font(.title2)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
            }
            
            
            if isEditing {
                VStack {
                    TextField("Enter food item", text: $newText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Button("Save") {
                        buttonText = newText
                        isEditing = false
                    }
                    .padding(.horizontal)
                }
            }
            
            
            if isEditing2 {
                VStack {
                    TextField("Enter expiry date", text: $newText2)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Button("Save") {
                        buttonText2 = newText2
                        isEditing2 = false
                    }
                    .padding(.horizontal)
                }
            }
            
            
            
            
            Spacer()
        }
    }
}

#Preview {
    ConfirmationView()
}

