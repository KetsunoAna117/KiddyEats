//
//  SaveToCollectionsButton.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import SwiftUI


struct LogReactionButton: View {
    let babyMeal: BabyMeal
    let vmd: BabyMealDetailDelegateViewModel
    
    @Environment(\.modelContext) var modelContext
    
    @State private var vm = ReactionLoggerViewModel(
        updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        NavigationLink {
            ReactionFormView(vm: vm, babyMeal: babyMeal)
        } label: {
            Text(babyMeal.reactionList.isEmpty ? "Log Reaction" : "Update Reaction")
                .font(.system(size: 12))
                .fontWeight(.bold)
        }
        .buttonStyle(KiddyEatsProminentButtonStyle())
        .onChange(of: vm.reactionDetails) {
            let reactions = vm.reactionDetails.compactMap {
                $0.rawValue
            }
            print("Reaction change: \(reactions)")

            vmd.reactionsDidChange?(reactions)
        }
    }
}
