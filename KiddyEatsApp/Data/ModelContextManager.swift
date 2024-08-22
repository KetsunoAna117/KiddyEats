//
//  ModelContextManager.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

class ModelContextManager {
    static var modelContainer: ModelContainer?
    
    // MARK: Initialization of model context
    static func createModelContainer() -> ModelContainer {
        let schema = setModelContainerSchema()
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            let container = try ModelContainer(for: schema, configurations: modelConfiguration)
            ModelContextManager.modelContainer = container
            return container
        } catch {
            fatalError("Couldn't create the model container: \(error)")
        }
    }
    
    private static func setModelContainerSchema() -> Schema {
        return Schema([
            BabyProfileSchema.self,
            BabyMealSchema.self
        ])
    }
    
}
