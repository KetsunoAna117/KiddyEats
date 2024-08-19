//
//  BabyProfileSchema.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

@Model
final class BabyProfileSchema {
    @Attribute(.unique) var id: UUID
    var name: String?
    var gender: String?
    var allergies: [String]?
    var dateOfBirth: Date?
    var location: String?
    
    @Relationship(deleteRule: .cascade, inverse: \BabyMealSchema.babyProfileSchema) var schemaList: [BabyMealSchema]?
    
    init(id: UUID, name: String? = nil, gender: String? = nil, allergies: [String]? = nil, dateOfBirth: Date? = nil, location: String? = nil, schemaList: [BabyMealSchema]? = nil) {
        self.id = id
        self.name = name
        self.gender = gender
        self.allergies = allergies
        self.dateOfBirth = dateOfBirth
        self.location = location
        self.schemaList = schemaList
    }
}
