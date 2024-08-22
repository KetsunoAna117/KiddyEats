//
//  BabyMealRepositoryProtocol.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol BabyMealRepositoryProtocol {
    func getBabyMealByID(modelContext: ModelContext, toFetchBabyMealID: UUID) -> BabyMealSchema?
	func getBabyMealList(modelContext: ModelContext) -> [BabyMealSchema]
	func deleteBabyMeal(modelContext: ModelContext, toDeleteBabyMealID: UUID)
    func saveBabyMeal(modelContext: ModelContext, toSaveBabyMealSchema: BabyMealSchema)
    func updateBabyMealReaction(modelContext: ModelContext, babyMealID: UUID, toUpdateReaction: [String])
}
