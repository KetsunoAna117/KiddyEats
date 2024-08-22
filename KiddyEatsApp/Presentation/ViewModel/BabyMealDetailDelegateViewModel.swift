//
//  BabyMealDetailViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation
import SwiftData

class BabyMealDetailDelegateViewModel
{
    var isFavorited: Bool = false

    var babyMeal: BabyMeal = BabyMeal(id: UUID(), name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0, isAllergic: false, hasFilledReaction: false, reactionList: []) {
        didSet {
            babyMealDidChange?(babyMeal)
        }
    }
    
    var isFavoritedDidChange: ((Bool) -> Void)?
    var babyMealDidChange: ((BabyMeal) -> Void)?
    var reactionsDidChange: (([String]) -> Void)?
    
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
    
    
}
