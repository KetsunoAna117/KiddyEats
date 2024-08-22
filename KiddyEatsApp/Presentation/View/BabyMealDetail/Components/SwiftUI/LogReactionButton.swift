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
    
    @State private var vm = ReactionLoggerViewModel(updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared))
    
    @State private var shouldNavigate: Bool = false
    
    var body: some View {
        VStack{
            NavigationLink(destination: ReactionFormView(babyMeal: babyMeal), isActive: $shouldNavigate) {
                EmptyView()
            }
            Button(action: {
                // Go to reaction page using NavigationLink
                shouldNavigate = true
            }) {
                Text(babyMeal.reactionList.isEmpty ? "Log Reaction" : "Update Reaction")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
            .buttonStyle(KiddyEatsProminentButtonStyle())
        }
    }
}
