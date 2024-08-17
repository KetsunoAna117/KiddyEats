//
//  BabyMealJsonPreview.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//
import SwiftUI

struct BabyMealTestView: View {
    @State private var resultText: String = ""
    
    var body: some View {
        ScrollView {
            Text(resultText)
                .padding()
        }
        .onAppear {
            resultText = BabyMeal.testIncompleteJson()
        }
    }
}

#Preview {
    BabyMealTestView()
}
