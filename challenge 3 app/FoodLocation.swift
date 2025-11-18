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
            let session = LanguageModelSession(
                model: SystemLanguageModel(useCase: .contentTagging)
            )
            
            let prompt = """
            ONLY REPLY WITH ONE WORD: FREEZER, FRIDGE OR PANTRY.  You are an algorithm that decides whether a food should be stored in the pantry, freezer or fridge. You are given the name of the food item: \(foodName). Reply only with fridge, freezer or pantry, based on where you think the food item should be stored. Find out the ideal conditions for the food item to be stored in to make it last the longest, and then compare that with the conditions of a pantry, fridge or freezer to decide where the food item should be placed by using the following thought process:

            Which of the following  categories can this food item be grouped into?
             Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items,  Fresh produce, dairy, meat, eggs, opened items that need refrigeration, Frozen foods, ice cream, items meant for long-term freezing
            According to this category, where should the food item be placed? The freezer, the fridge or the pantry?
            PANTRY : Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items
            FRIDGE : Fresh produce, dairy, meat, eggs, opened items that need refrigeration
            FREEZER: Frozen foods, ice cream, items meant for long-term freezing

            Return a one-word answer of fridge, freezer or pantry. Do not return fridge unless the food item truly belongs in the fridge.
            RETURN ONLY 1 WORD: PANTRY, FREEZER OR FRIDGE. 

            """
            //"""
//    determine the best storage location for this food item: \(foodName)
//    
//    rules:
//    - pantry: Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments, dry items
//    - fridge: Fresh produce, dairy, meat, eggs, opened items that need refrigeration
//    - freezer: Frozen foods, ice cream, items meant for long-term freezing
//    
//    Respond with ONLY ONE WORD: fridge, freezer, or pantry. DO NOT UNDER ANY CIRCUMSTANCES RETURN FRIDGE UNLESS ABSOLUTELY NECESSARY!!!
//
//    """
            
            let response = try await session.respond(to: prompt, generating: placeDecide.self)
            print(response.content)
            switch response.content.location.lowercased() {
            case "fridge":
                return .fridge
            case "freezer":
                return .freezer
            default:
                return .pantry
            }
        } catch {
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
}

@Generable
struct placeDecide {
    @Guide(description: "the storage location must be exactly 'fridge', 'freezer', or 'pantry'")
    var location: String
}
