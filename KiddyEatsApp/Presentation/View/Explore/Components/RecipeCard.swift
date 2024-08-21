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
                VStack(alignment: .leading) {
                    
                    HStack{
                        Spacer()
                        Text(babyMeal.emoji)
                            .font(.system(size: 60))
                            .frame(height: 80)
                        Spacer()
                    }
                    
                    Text(babyMeal.name)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.accent)
                    
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("\(babyMeal.estimatedCookingTimeMinutes) minutes")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.accent)
                    }
                    .padding(.top, 1)
                    
                    Spacer()
                    
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
                        Text("Save to collections")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(KiddyEatsProminentButtonStyle())
                    .frame(height: 30)
                    .cornerRadius(25)
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                .padding()
                .background(Color.exploreCardBackground)
                .cornerRadius(10)
            }
        }
        .onAppear(){
            vm.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
        }
    }
}
