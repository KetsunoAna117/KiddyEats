//
//  ReactionLoggerViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import Foundation

@Observable class ReactionLoggerViewModel {
    var selectedBabyMeal: BabyMeal?
    
    var reactionStatus: ReactionStatus
    var reactionDetails: [ReactionDetails]
    
    init() {
        self.reactionStatus = .unfilled
        self.reactionDetails = []
    }
    
    func setupBabyMeal(selectedBabyMeal: BabyMeal) {
        self.selectedBabyMeal = selectedBabyMeal
    }
    
    
}
