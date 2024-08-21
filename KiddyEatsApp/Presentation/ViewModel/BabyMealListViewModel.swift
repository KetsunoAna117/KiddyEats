//
//  BabyMealListViewModel.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

@Observable
class BabyMealListViewModel {
	var searchRecipe: String = ""
	var selectedView: CollectionSegment = .favoriteRecipes
	
	var allMealList: [BabyMeal] = []
	var showedMealList: [BabyMeal] = []
	
	// Use Case
	private let getBabyMealListUseCase: GetBabyMealListProtocol
	private let getFilterBabyMeal: FilterBabyMealProtocol
	private let getBabyMealAllergicList: GetBabyMealAllergicListProtocol
	private let deleteBabyMealUseCase: DeleteBabyMealProtocol
	
	init(
		getBabyMealListUseCase: GetBabyMealListProtocol,
		getFilterBabyMeal: FilterBabyMealProtocol,
		getBabyMealAllergicList: GetBabyMealAllergicListProtocol,
		deleteBabyMealUseCase: DeleteBabyMealProtocol
	) {
		self.getBabyMealListUseCase = getBabyMealListUseCase
		self.getFilterBabyMeal = getFilterBabyMeal
		self.getBabyMealAllergicList = getBabyMealAllergicList
		self.deleteBabyMealUseCase = deleteBabyMealUseCase
	}
	
	func initAllMealList(modelContext: ModelContext) {
		self.allMealList = getBabyMealListUseCase.execute(modelContext: modelContext)
	}
	
	func setFavoriteList() {
		self.showedMealList = allMealList.map { $0 }
	}
	
	func filterRecipe(modelContext: ModelContext) {
		self.showedMealList = getFilterBabyMeal.execute(babyMeal: allMealList, searchQuery: searchRecipe)
	}
	
	func getMealAllergic(modelContext: ModelContext) {
		self.showedMealList = getBabyMealAllergicList.execute(babyMeal: showedMealList)
	}
	
	func deleteBabyMeal(modelContext: ModelContext, toDeleteBabyMeal: BabyMeal) {
        deleteBabyMealUseCase.execute(modelContext: modelContext, toDeleteBabyMealID: toDeleteBabyMeal.id)
	}
}
