//
//  BabyMealDetailViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation
import SwiftData

@Observable
class BabyMealDetailViewModel {
    var isFavorited: Bool = false
    
    // Use Case
    private var saveBabyMealUseCase: SaveBabyMealUseCaseProtocol
    private var deleteBabyMealUseCase: DeleteBabyMealProtocol
    private var getBabyMealUseCase: GetBabymealUseCaseProtocol
    
    private var vmd: BabyMealDetailDelegateViewModel?
    
    init(
        saveBabyMealUseCase: SaveBabyMealUseCaseProtocol,
        deleteBabyMealUseCase: DeleteBabyMealProtocol,
        getBabyMealUseCase: GetBabymealUseCaseProtocol
    ) {
        self.saveBabyMealUseCase = saveBabyMealUseCase
        self.deleteBabyMealUseCase = deleteBabyMealUseCase
        self.getBabyMealUseCase = getBabyMealUseCase
    }
    
    func setVmd(vmd: BabyMealDetailDelegateViewModel) {
        self.vmd = vmd
    }
    
    func saveMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        saveBabyMealUseCase.execute(modelContext: modelContext, toSaveBabyMeal: babyMeal)
    }
    
    func deleteMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        deleteBabyMealUseCase.execute(modelContext: modelContext, toDeleteBabyMealID: babyMeal.id)
    }
    
    func checkIfAlreadyFavorite(modelContext: ModelContext, babyMealID: UUID){
        let fetchedBabyMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMealID)
        if fetchedBabyMeal == nil {
            self.isFavorited = false
        }
        else {
            self.isFavorited = true
        }
        self.vmd?.isFavoritedDidChange?(self.isFavorited)
    }
    
    func updateBabyMeal(modelContext: ModelContext, babyMeal: BabyMeal) {
        guard let fetchedBabyMeal = getBabyMealUseCase.execute(modelContext: modelContext, id: babyMeal.id) else {
            print("No baby meal")
            return
        }
        
        guard let vmd = vmd else {
            print("No vmd")
            return
        }
            
        vmd.babyMeal = fetchedBabyMeal
        
    }
}
