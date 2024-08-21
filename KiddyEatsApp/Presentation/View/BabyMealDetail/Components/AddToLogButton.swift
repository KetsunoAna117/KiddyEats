//
//  SaveToCollectionsButton.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import SwiftUI

struct SaveToCollectionsButton: View {
    let babyMeal: BabyMeal
    
    var body: some View {
        Button(action: saveToCollections) {
            Text("Save to collections")
        }
        .buttonStyle(KiddyEatsProminentButtonStyle())
    }
    
    func saveToCollections() {
        print("Save to collections")
    }
}
