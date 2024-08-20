//
//  BabyMealDetailViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation
import SwiftData

@Observable class BabyMealDetailViewModel {
    var isFavorited: Bool = false
    
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
    
    func saveMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        print("Try to save meal")
        saveBabyMealUseCase.execute(modelContext: modelContext, toSaveBabyMeal: babyMeal)
    }
    
    func deleteMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        print("Try to delete meal")
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
