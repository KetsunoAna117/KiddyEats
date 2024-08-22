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
    
    @State private var vm = ReactionLoggerViewModel(
        updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        NavigationLink {
            ReactionFormView(babyMeal: babyMeal)
        } label: {
            Text(babyMeal.reactionList.isEmpty ? "Log Reaction" : "Update Reaction")
                .font(.system(size: 12))
                .fontWeight(.bold)
        }
        .buttonStyle(KiddyEatsProminentButtonStyle())
    }
}
