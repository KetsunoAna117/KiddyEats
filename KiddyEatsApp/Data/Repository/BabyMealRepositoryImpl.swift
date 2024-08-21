//
//  BabyMealRepositoryImpl.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

struct BabyMealRepositoryImpl {
    private init() {}
    
    static let shared = BabyMealRepositoryImpl()
}

extension BabyMealRepositoryImpl: BabyMealRepositoryProtocol {
    func saveBabyMeal(modelContext: ModelContext, toSaveBabyMealSchema: BabyMealSchema) {
        modelContext.insert(toSaveBabyMealSchema)
        try? modelContext.save()
    }
    
    func updateBabyMealReaction(modelContext: ModelContext, babyMealID: UUID, toUpdateReaction: [String]) {
        if let fetchedBabyMeal = getBabyMealByID(modelContext: modelContext, toFetchBabyMealID: babyMealID) {
            fetchedBabyMeal.reactionList = toUpdateReaction
            try? modelContext.save()
        }
    }
    
    func deleteBabyMeal(modelContext: ModelContext, toDeleteBabyMealID: UUID) {
        do {
            try modelContext.delete(model: BabyMealSchema.self, where: #Predicate{
                $0.id == toDeleteBabyMealID
            })
        } catch {
            print("Meal already deleted")
        }
        
    }
    
    func getBabyMealByID(modelContext: ModelContext, toFetchBabyMealID: UUID) -> BabyMealSchema? {
        let descriptor = FetchDescriptor<BabyMealSchema>(
            predicate: #Predicate { $0.id == toFetchBabyMealID }
        )
        
        guard let fetchedBabyMealSchema = try? modelContext.fetch(descriptor) else {
            return nil
        }
        
        return fetchedBabyMealSchema.first
    }
    
    func getBabyMealList(modelContext: ModelContext) -> [BabyMealSchema] {
        let descriptor = FetchDescriptor<BabyMealSchema>()
        
        guard let fetchedBabyMeal = try? modelContext.fetch(descriptor) else {
            print("There's no baby meal schema in db")
            return []
        }
        
        return fetchedBabyMeal
    }
}
