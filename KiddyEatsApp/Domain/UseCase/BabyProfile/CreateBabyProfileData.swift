//
//  CreateBabyProfileDaata.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

protocol CreateBabyProfileDataProtocol {
    func execute(modelContext: ModelContext, babyProfileData: BabyProfile)
}

struct CreateBabyProfileData: CreateBabyProfileDataProtocol {
    let repo: BabyProfileRepositoryProtocol
    
    func execute(modelContext: ModelContext, babyProfileData: BabyProfile) {
        if (repo.getBabyProfile(modelContext: modelContext)) != nil {
            return
        }
        repo.createBabyProfile(modelContext: modelContext, babyProfile: babyProfileData)
        
    }
}
