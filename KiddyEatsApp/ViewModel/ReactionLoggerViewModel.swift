//
//  ReactionLoggerViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import Foundation

@Observable class ReactionLoggerViewModel {
    var reactionStatus: ReactionStatus
    var reactionDetails: [ReactionDetails]
    
    init() {
        self.reactionStatus = .unfilled
        self.reactionDetails = []
    }
}
