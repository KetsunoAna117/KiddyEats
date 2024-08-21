//
//  ReactionLoggerViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import Foundation
import SwiftData

@Observable class ReactionLoggerViewModel {
    var selectedBabyMeal: BabyMeal?
    
    var reactionStatus: ReactionStatus
    var reactionDetails: [ReactionDetails]
    
    // Use Case
    private var updateReactionUseCase: UpdateBabyMealReactionUseCaseProtocol
    
    init(
        updateReactionUseCase: UpdateBabyMealReactionUseCaseProtocol
    ) {
        self.reactionStatus = .unfilled
        self.reactionDetails = []
        self.updateReactionUseCase = updateReactionUseCase
    }
    
    func setupBabyMeal(selectedBabyMeal: BabyMeal) {
        self.selectedBabyMeal = selectedBabyMeal
    }
    
    func updateBabyMealReaction(modelContext: ModelContext){
        if let selectedBabyMeal = selectedBabyMeal {
            updateReactionUseCase.execute(
                modelContext: modelContext,
                babyMealID: selectedBabyMeal.id,
                reactionList: reactionDetails
            )
        }

    }
    
    
}
