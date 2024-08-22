//
//  BabyMealDetailViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation
import SwiftData

@Observable
class BabyMealDetailViewModel {
    
    var isFavorited: Bool = false {
        didSet {
            isFavoritedDidChange?(isFavorited)
        }
    }
    
    var babyMeal: BabyMeal = BabyMeal(id: UUID(), name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0, isAllergic: false, hasFilledReaction: false, reactionList: []) {
        didSet {
            babyMealDidChange?(babyMeal)
        }
    }
    
    var isFavoritedDidChange: ((Bool) -> Void)?
    var babyMealDidChange: ((BabyMeal) -> Void)?
    
    // Use Case
    private var saveBabyMealUseCase: SaveBabyMealUseCaseProtocol
    private var deleteBabyMealUseCase: DeleteBabyMealProtocol
    private var getBabyMealUseCase: GetBabymealUseCaseProtocol
    
    
    init(
        saveBabyMealUseCase: SaveBabyMealUseCaseProtocol,
        deleteBabyMealUseCase: DeleteBabyMealProtocol,
        getBabyMealUseCase: GetBabymealUseCaseProtocol
    ) {
        self.saveBabyMealUseCase = saveBabyMealUseCase
        self.deleteBabyMealUseCase = deleteBabyMealUseCase
        self.getBabyMealUseCase = getBabyMealUseCase
    }
    
    @MainActor
    func setBabyMeal(babyMeal: BabyMeal) {
        self.babyMeal = getBabyMeal(babyMeal: babyMeal)
    }
    
    @MainActor
    func getBabyMeal(babyMeal: BabyMeal) -> BabyMeal {
        guard let modelContext = ModelContextManager.modelContainer?.mainContext else {
            print("Failed to get model context")
            return babyMeal
        }
        
        guard let newMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMeal.id) else {
            print("Failed to fetch updated meal with id: \(babyMeal.id)")
            return babyMeal
        }
        
        return newMeal
    }
    
    @MainActor
    func checkIfAlreadyFavoriteUikit(babyMeal: BabyMeal){
        guard let modelContext = ModelContextManager.modelContainer?.mainContext else {
            print("Failed to get model context")
            return
        }
        
        let fetchedBabyMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMeal.id)
        
        if fetchedBabyMeal == nil {
            self.isFavorited = false
        }
        else {
            self.isFavorited = true
        }
    }
    
    func saveMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        saveBabyMealUseCase.execute(modelContext: modelContext, toSaveBabyMeal: babyMeal)
    }
    
    func deleteMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        deleteBabyMealUseCase.execute(modelContext: modelContext, toDeleteBabyMealID: babyMeal.id)
    }
    
    func checkIfAlreadyFavorite(modelContext: ModelContext, babyMealID: UUID){
        let fetchedBabyMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMealID)
        if fetchedBabyMeal == nil {
            self.isFavorited = false
        }
        else {
            self.isFavorited = true
        }
    }
}
