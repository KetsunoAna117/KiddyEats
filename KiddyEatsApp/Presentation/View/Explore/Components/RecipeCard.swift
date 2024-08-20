//
//  RecipeCard.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import SwiftUI
import SwiftData

struct RecipeCard: View {
    @Environment(\.modelContext) var modelContext
    
    let babyMeal: BabyMeal
    @State private var vm = BabyMealDetailViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if babyMeal.name.isEmpty {
                LoadingCard()
            } else {
                VStack {
                    Text(babyMeal.emoji)
                        .font(.system(size: 60))
                        .frame(height: 100)
                    
                    Text(babyMeal.name)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                .padding()
                .background(Color.exploreCardBackground)
                .cornerRadius(10)
                
                Button(action: {
                    // Save to swiftData if isn't favorited
                    if vm.isFavorited == false {
                        print("save meal for \(babyMeal.name)")
                        vm.saveMeal(modelContext: modelContext, babyMeal: babyMeal)
                    }
                    // Delete from swiftData if already favorited
                    else {
                        print("delete meal for \(babyMeal.name)")
                        vm.deleteMeal(modelContext: modelContext, babyMeal: babyMeal)
                    }
                    vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
                }) {
                    Image(systemName: vm.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.accent)
                }
                .scaleEffect(1.5)
                .padding(.top, 15)
                .padding(.trailing, 15)
            }
        }
    }
}
