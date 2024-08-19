//
//  DummyModelContainer.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import Foundation
import SwiftData

class DummyModelContainer {
	@MainActor
	static func createCombinedContainer() -> ModelContainer {
		let combinedSchema = createSchema()
		let combinedConfiguration = ModelConfiguration()
		let combinedContainer = try! ModelContainer(for: combinedSchema, configurations: combinedConfiguration)
		
		DummyRecipeModel.recipeDefaults.forEach { combinedContainer.mainContext.insert($0) }
		
		return combinedContainer
	}
	
	private static func createSchema() -> Schema {
		return Schema([
			DummyRecipeModel.self
		])
	}
}
