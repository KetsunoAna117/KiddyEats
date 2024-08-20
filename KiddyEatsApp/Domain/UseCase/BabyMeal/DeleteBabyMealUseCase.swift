//
//  DeleteBabyMeal.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol DeleteBabyMealProtocol {
	func execute(modelContext: ModelContext, toDeleteBabyMeal: BabyMeal)
}

struct DeleteBabyMealUseCase: DeleteBabyMealProtocol {
	let repo: BabyMealRepositoryProtocol
	
	func execute(modelContext: ModelContext, toDeleteBabyMeal: BabyMeal) {
		let toDeleteBabyMealSchema = toDeleteBabyMeal.mapToBabyMealSchema()
		repo.deleteBabyMeal(modelContext: modelContext, toDeleteBabyMealSchema: toDeleteBabyMealSchema)
	}
}
