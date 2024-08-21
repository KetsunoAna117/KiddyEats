//
//  GetBabymealUseCase.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 20/08/24.
//

import Foundation
import SwiftData

protocol GetBabymealUseCaseProtocol {
    func execute(modelContext: ModelContext, id: UUID) -> BabyMeal?
}

struct GetBabymealUseCase: GetBabymealUseCaseProtocol {
    let repo: BabyMealRepositoryProtocol
    
    func execute(modelContext: ModelContext, id: UUID) -> BabyMeal? {
        if let fetchedBabyMeal = repo.getBabyMealByID(modelContext: modelContext, toFetchBabyMealID: id) {
            return fetchedBabyMeal.mapToBabyMeal()
        }
        return nil
    }
    
    
}
