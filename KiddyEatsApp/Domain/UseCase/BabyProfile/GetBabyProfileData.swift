//
//  GetBabyProfileData.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

protocol GetBabyProfileDataProtocol {
    func execute(modelContext: ModelContext) -> BabyProfile?
}

struct GetBabyProfileData: GetBabyProfileDataProtocol {
    var repo: BabyProfileRepositoryProtocol
    
    func execute(modelContext: ModelContext) -> BabyProfile? {
        let result = repo.getBabyProfile(modelContext: modelContext)
        return result?.mapToBabyProfile()
    }
    
    
}
