//
//  UpdateBabyMealReaction.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 21/08/24.
//

import Foundation
import SwiftData

protocol UpdateBabyMealReactionUseCaseProtocol {
    func execute(modelContext: ModelContext, babyMealID: UUID, reactionList: [ReactionDetails])
}

struct UpdateBabyMealReactionUseCase: UpdateBabyMealReactionUseCaseProtocol {
    let repo: BabyMealRepositoryProtocol
    
    func execute(modelContext: ModelContext, babyMealID: UUID, reactionList: [ReactionDetails]) {
        let stringReactionList = reactionList.map {
            $0.rawValue
        }
        
        repo.updateBabyMealReaction(modelContext: modelContext, babyMealID: babyMealID, toUpdateReaction: stringReactionList)
    }
}
