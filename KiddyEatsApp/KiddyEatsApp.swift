//
//  KiddyEatsAppApp.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 15/08/24.
//

import SwiftUI
import SwiftData

@main
@MainActor
struct KiddyEatsApp: App {
    var modelContainer = ModelContextManager.createModelContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
		.modelContainer(DummyModelContainer.createCombinedContainer())
    }
}
