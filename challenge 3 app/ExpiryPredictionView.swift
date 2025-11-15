//
//  SwiftUIView.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 15/11/25.
//

import SwiftUI
import FoundationModels
struct SwiftUIView: View {
    var body: some View {
        Button("Predict Expiration Date"){
            Task{
                let instructions = """
You are a shelf life predictor. I want you to predict how long a food will last in my house based on where I store it (Fridge, Freezer or Pantry), the date I bought it from the supermarket as well as the name of the food.
You will be given a place (fridge, freezer or pantry), the date the food was bought and the name of the food item. You are to respond with the 

"""
                let session = LanguageModelSession()
                let response = try await session.respond(to: "Hello! what is the eretaher")
                print(response.content)
                //struct for format
                //instrcutions go in function
                //change prompt accordingly
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
