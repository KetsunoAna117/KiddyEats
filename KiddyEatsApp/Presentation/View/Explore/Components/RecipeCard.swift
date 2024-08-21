//
//  RecipeCard.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import SwiftUI
import SwiftData

struct RecipeCard: View {
    let babyMeal: BabyMeal
    
    @Environment(\.modelContext) var modelContext
    
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
                    
                    SaveToCollectionsButton(babyMeal: babyMeal)
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
