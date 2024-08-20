//
//  BabyMealRepositoryProtocol.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol BabyMealRepositoryProtocol {
	func getBabyMealList(modelContext: ModelContext) -> [BabyMealSchema]
	func deleteBabyMeal(modelContext: ModelContext, toDeleteBabyMealSchema: BabyMealSchema)
}
