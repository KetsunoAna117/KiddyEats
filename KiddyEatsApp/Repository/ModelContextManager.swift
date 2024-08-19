//
//  ModelContextManager.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

@MainActor
class ModelContextManager {
    static let shared = ModelContextManager()
    
    var modelContext: ModelContext
    
    private init(){
        let container = ModelContextManager.createModelContainer()
        self.modelContext = container.mainContext
    }
    
    
    // MARK: Initialization of model context
    static func createModelContainer() -> ModelContainer {
        let schema = setModelContainerSchema()
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            let container = try ModelContainer(for: schema, configurations: modelConfiguration)
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
