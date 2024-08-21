//
//  BabyRepositoryProtocol.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

protocol BabyProfileRepositoryProtocol {
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema?
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfileSchema)
}
