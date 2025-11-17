//
//  foodPlace.swift
//  challenge 3 app
//
//  Created by Ashley Leng on 16/11/25.
//

    import Foundation
    import FoundationModels

    class foodPlace {
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
                
                let prompt = """
    determine the best storage location for this food item: \(foodName)

    rules:
    - pantry: Canned goods, dry goods, unopened shelf-stable items, alcohol, condiments
    - fridge: Fresh produce, dairy, meat, eggs, opened items that need refrigeration
    - freezer: Frozen foods, ice cream, items meant for long-term freezing

    Respond with ONLY ONE WORD: fridge, freezer, or pantry
    """
                
                let response = try await session.respond(to: prompt, generating: placeDecide.self)
                
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
