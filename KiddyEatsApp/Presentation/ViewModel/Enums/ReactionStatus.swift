//
//  ReactionStatus.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import Foundation

enum ReactionStatus {
    case unfilled
    case hadReaction
    case noReaction
    
    var value: Bool {
        switch self {
        case .unfilled:
            return false
        case .hadReaction:
            return true
        case .noReaction:
            return false
        }
    }
}
