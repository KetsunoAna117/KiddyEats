//
//  SaveToCollectionsButton.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import SwiftUI


struct LogReactionButton: View {
    let babyMeal: BabyMeal
    
    @Environment(\.modelContext) var modelContext
    
    @State private var vm = BabyMealDetailViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        Button(action: {
            // Go to reaction page using NavigationLink
        }) {
            Text("Log Reaction")
                .font(.system(size: 12))
                .fontWeight(.bold)
        }
        .buttonStyle(KiddyEatsProminentButtonStyle())
    }
}
