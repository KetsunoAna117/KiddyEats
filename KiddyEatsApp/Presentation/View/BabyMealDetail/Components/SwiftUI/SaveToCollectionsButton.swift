//
//  SaveToCollectionsButton.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import SwiftUI

struct SaveToCollectionsButton: View {
    let babyMeal: BabyMeal
    
    @Environment(\.modelContext) var modelContext
    
    @State private var vm = BabyMealDetailViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
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
        .onAppear() {
            vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
        }
    }
    
    func saveToCollections() {
        print("Save to collections")
    }
}

