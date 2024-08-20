//
//  SaveBabyMealUseCase.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 20/08/24.
//

import Foundation
import SwiftData

protocol SaveBabyMealUseCaseProtocol {
    func execute(modelContext: ModelContext, toSaveBabyMeal: BabyMeal)
}

struct SaveBabyMealUseCase: SaveBabyMealUseCaseProtocol {
    let repo: BabyMealRepositoryProtocol
    
    func execute(modelContext: ModelContext, toSaveBabyMeal: BabyMeal) {
        let toSaveBabyMealSchema = toSaveBabyMeal.mapToBabyMealSchema()
        repo.saveBabyMeal(modelContext: modelContext, toSaveBabyMealSchema: toSaveBabyMealSchema)
        
        print("Try to save babyMeal: \(toSaveBabyMeal.name)")
        let debug = repo.getBabyMealList(modelContext: modelContext)
        for data in debug {
            print(data.name ?? "")
        }
    }
    
    
}
