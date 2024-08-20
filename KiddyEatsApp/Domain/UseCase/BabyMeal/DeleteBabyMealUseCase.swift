//
//  DeleteBabyMeal.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol DeleteBabyMealProtocol {
	func execute(modelContext: ModelContext, toDeleteBabyMealID: UUID)
}

struct DeleteBabyMealUseCase: DeleteBabyMealProtocol {
	let repo: BabyMealRepositoryProtocol
	
	func execute(modelContext: ModelContext, toDeleteBabyMealID: UUID) {
		repo.deleteBabyMeal(modelContext: modelContext, toDeleteBabyMealID: toDeleteBabyMealID)
        
        let debug = repo.getBabyMealList(modelContext: modelContext)
        for data in debug {
            print(data.name ?? "")
        }
	}
}
