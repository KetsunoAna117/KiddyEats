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
	func getBabyMealList(modelContext: ModelContext) -> [BabyMealSchema] {
		let descriptor = FetchDescriptor<BabyMealSchema>()
		
		guard let fetchedBabyMeal = try? modelContext.fetch(descriptor) else {
			print("There's no baby meal schema in db")
			return []
		}
		
		return fetchedBabyMeal
	}
	
	func deleteBabyMeal(modelContext: ModelContext, toDeleteBabyMealSchema: BabyMealSchema) {
		modelContext.delete(toDeleteBabyMealSchema)
		try? modelContext.save()
	}
}
