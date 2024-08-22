//
//  SaveToCollectionsButton.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import SwiftUI

struct RecipeCardSaveToCollectionsButton: View {
    let babyMeal: BabyMeal
    
    @Environment(\.modelContext) var modelContext
    
    @State private var vm = BabyMealDetailViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    @State private var reactionVm = ReactionLoggerViewModel(
        updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        Button(action: {
            // Save to swiftData if isn't favorited
            if vm.isFavorited == false {
                vm.saveMeal(modelContext: modelContext, babyMeal: babyMeal)
            }
            // Delete from swiftData if already favorited
            else {
                vm.deleteMeal(modelContext: modelContext, babyMeal: babyMeal)
            }
            vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
        }) {
            if vm.isFavorited {
                Text("Remove recipe")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
            else {
                Text("Save to collections")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
        }
        .opacity(vm.isFavorited ? 0.75 : 1.0)
        .buttonStyle(KiddyEatsMiniProminentButtonStyle())
        .onAppear() {
            vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
        }
    }
}

struct MealDetailSaveToCollectionsButton: View {
    let babyMeal: BabyMeal
    let vmd: BabyMealDetailDelegateViewModel
    
    @Environment(\.modelContext) var modelContext
    
    @State private var vm = BabyMealDetailViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        if vm.isFavorited {
            Button(action: {
                // Save to swiftData if isn't favorited
                if vm.isFavorited == false {
                    vm.saveMeal(modelContext: modelContext, babyMeal: babyMeal)
                }
                // Delete from swiftData if already favorited
                else {
                    vm.deleteMeal(modelContext: modelContext, babyMeal: babyMeal)
                }
                vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
            }) {
                if vm.isFavorited {
                    Text("Remove recipe")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
                else {
                    Text("Save to collections")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
            }
            .buttonStyle(KiddyEatsBorderlessButtonStyle())
            .onAppear() {
                vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
            }
        } else {
            Button(action: {
                // Save to swiftData if isn't favorited
                if vm.isFavorited == false {
                    vm.saveMeal(modelContext: modelContext, babyMeal: babyMeal)
                }
                // Delete from swiftData if already favorited
                else {
                    vm.deleteMeal(modelContext: modelContext, babyMeal: babyMeal)
                }
                vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
            }) {
                if vm.isFavorited {
                    Text("Remove recipe")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
                else {
                    Text("Save to collections")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
            }
            .buttonStyle(KiddyEatsProminentButtonStyle())
            .onAppear() {
                vm.setVmd(vmd: vmd)
                vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
                vm.updateBabyMeal(modelContext: modelContext, babyMeal: babyMeal)
            }
        }
        
    }
}

