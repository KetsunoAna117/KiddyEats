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
    private var getBabyMealUseCase: GetBabymealUseCaseProtocol
    
    init(
        updateReactionUseCase: UpdateBabyMealReactionUseCaseProtocol,
        getBabyMealUseCase: GetBabymealUseCaseProtocol
    ) {
        self.reactionStatus = .unfilled
        self.reactionDetails = []
        self.updateReactionUseCase = updateReactionUseCase
        self.getBabyMealUseCase = getBabyMealUseCase
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
            checkReaction(modelContext: modelContext, babyMealID: selectedBabyMeal.id)
        }
    }
    
    func checkReaction(modelContext: ModelContext, babyMealID: UUID){
        guard let fetchedBabyMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMealID) else {
            print("Can't check reaction")
            return
        }
        reactionDetails = fetchedBabyMeal.reactionList.compactMap { rawValue in
            ReactionDetails(rawValue: rawValue)
        }
    }
    
}
