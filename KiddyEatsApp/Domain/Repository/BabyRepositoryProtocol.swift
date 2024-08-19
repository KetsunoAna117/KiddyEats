//
//  BabyRepositoryProtocol.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

protocol BabyRepositoryProtocol {
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema?
}
