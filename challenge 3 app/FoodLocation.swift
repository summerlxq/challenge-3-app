//
//  FoodLocation.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 16/11/25.
//

import Foundation
import FoundationModels

class FoodLocation {
    static func getStorageLocation(for foodName: String) async -> Foodtype {
        let model = SystemLanguageModel.default
        if case .available = model.availability {
            return await aiStorageLocation(for: foodName)
        } else {
            return normalStorageLocation(for: foodName)
        }
    }
    
    private static func aiStorageLocation(for foodName: String) async -> Foodtype {
        do {
            let session = LanguageModelSession()
            
//            let prompt = """
//            ONLY REPLY WITH ONE WORD: FREEZER, FRIDGE OR PANTRY.  You are an algorithm that decides whether a food should be stored in the pantry, freezer or fridge. You are given the name of the food item: \(foodName). Reply only with fridge, freezer or pantry, based on where you think the food item should be stored. Find out the ideal conditions for the food item to be stored in to make it last the longest, and then compare that with the conditions of a pantry, fridge or freezer to decide where the food item should be placed by using the following thought process:
//            
//            Which of the following  categories can this food item be grouped into?
//             Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items,  Fresh produce, dairy, meat, eggs, opened items that need refrigeration, Frozen foods, ice cream, items meant for long-term freezing
//            According to this category, where should the food item be placed? The freezer, the fridge or the pantry?
//            PANTRY : Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items
//            FRIDGE : Fresh produce, dairy, meat, eggs, opened items that need refrigeration
//            FREEZER: Frozen foods, ice cream, items meant for long-term freezing
//            
//            Return a one-word answer of fridge, freezer or pantry. Do not return fridge unless the food item truly belongs in the fridge.
//            RETURN ONLY 1 WORD: PANTRY, FREEZER OR FRIDGE. 
//            
//            """
            let prompt =
                """
                determine the best storage location for this food item: \(foodName)
                
                rules:
                - pantry: Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items
                - fridge: Fresh produce, dairy, meat, eggs, opened items that need refrigeration
                - freezer: Frozen foods, ice cream, items meant for long-term freezing
                
                Respond with ONLY ONE WORD: fridge, freezer, or pantry. DO NOT UNDER ANY CIRCUMSTANCES RETURN FRIDGE UNLESS ABSOLUTELY NECESSARY!!!
                
                """
            
            let response = try await session.respond(to: prompt, generating: Foodtype.self)
            print(response.content)
            return response.content
        } catch {
            print(error.localizedDescription)
            return normalStorageLocation(for: foodName)
        }
    }
    
    private static func normalStorageLocation(for foodName: String) -> Foodtype {
        print("yes func")
        let name = foodName.lowercased()
        
        let fridgeKeywords = ["milk", "cheese", "yogurt", "butter", "eggs", "meat", "chicken", "fish", "lettuce", "fresh", "produce", "bread"]
        let freezerKeywords = ["ice cream", "frozen"]
        
        if fridgeKeywords.contains(where: { name.contains($0) }) {
            return .fridge
        } else if freezerKeywords.contains(where: { name.contains($0) }) {
            return .freezer
        } else {
            return .pantry
        }
    }
     static func predictExpiry(foodName: String, foodType: Foodtype )async -> FoodItem{
        do {
            let session = LanguageModelSession()
            let prompt = """
You are a food safety expert. Predict the expiration date for the following food item with high accuracy.

Food Item: \(foodName)
Purchase Date: \(Date())
Storage Location: \(foodType)

Instructions:
- Use USDA guidelines and standard food safety data
- Consider typical shelf life for \(foodName) stored in \(foodType)
- Account for the purchase date
- The expiration date MUST be AFTER the purchase date
- Be realistic and accurate based on real-world food storage times
- For unopened items in proper storage conditions

Provide the predicted expiration date.
"""
            
            let response = try await session.respond(to: prompt, generating: Prediction.self)
            let expiryDateString = response.content.expiryDate
            
//            if let index = foodItems.firstIndex(where: { $0.id == item.id }) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
            let expiryDate = dateFormatter.date(from: expiryDateString)
//                if let expiryDate = dateFormatter.date(from: prediction.expiryDate),
//                   expiryDate > item.dateScanned {
//                    modelContext.insert(FoodItem(
//                        nameOfFood: foodName,
//                        dateScanned: Date(),
//                        dateExpiring: expiryDate,
//                        storageLocation: foodType
//                    ))
//                }
//            }
            return FoodItem(nameOfFood: foodName, dateExpiring: expiryDate ?? Date(), storageLocation: foodType)
        } catch {
            print("Error predicting for \(foodName): \(error)")
            return FoodItem(nameOfFood: foodName, dateExpiring: Date(), storageLocation: foodType)
        }
    }
}

@Generable
struct Prediction {
    @Guide(description: "The predicted expiration date in YYYY-MM-DD format based on USDA guidelines and standard shelf life for this specific food in the given storage location")
    var expiryDate: String
}

//@Generable
//struct placeDecide {
//    @Guide(description: "the storage location must be exactly 'fridge', 'freezer', or 'pantry'")
//    var location: Foodtype
//}
