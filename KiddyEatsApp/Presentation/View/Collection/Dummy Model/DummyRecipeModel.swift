//
//  DummyRecipeModel.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 16/08/24.
//

import Foundation
import SwiftData

@Model
final class DummyRecipeModel {
	@Attribute(.unique)
	var dummyName: String
	var dummyEmoji: String
	var dummyIsLiked: Bool
	var dummyIsAllergic: Bool
	
	init(dummyName: String = "",
		 dummyEmoji: String = "",
		 dummyIsLiked: Bool = false,
		 dummyIsAllergic: Bool = false) {
		self.dummyName = dummyName
		self.dummyEmoji = dummyEmoji
		self.dummyIsLiked = dummyIsLiked
		self.dummyIsAllergic = dummyIsAllergic
	}
}

extension DummyRecipeModel {
	static var recipeDefaults: [DummyRecipeModel] {[
		.init(dummyName: "Beef Burger", dummyEmoji: "🍔", dummyIsLiked: true, dummyIsAllergic: false),
		.init(dummyName: "Hot Dog", dummyEmoji: "🌭", dummyIsLiked: true, dummyIsAllergic: true)
	]}
}
