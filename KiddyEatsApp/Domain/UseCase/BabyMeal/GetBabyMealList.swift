//
//  GetBabyMealList.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol GetBabyMealListProtocol {
	func execute(modelContext: ModelContext) -> [BabyMeal]
}

struct GetBabyMealListUseCase: GetBabyMealListProtocol {
	let repo: BabyMealRepositoryProtocol
	
	func execute(modelContext: ModelContext) -> [BabyMeal] {
		let result = repo.getBabyMealList(modelContext: modelContext)
		return result.map { $0.mapToBabyMeal() }
	}
	
	
}
