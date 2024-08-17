//
//  GenderChoice.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingGenderChoice: View {
    let imageEmoji: String
    let type: Gender
    
    @Binding var isSelected: Gender
    
    var body: some View {
        VStack {
            VStack {
                Text(imageEmoji)
                    .font(Font.system(size: 64))
            }
            .frame(width: 120, height: 120)
            .background(){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected == type ? Color.accentColor : Color.clear)
                    
            )
            Text(type.rawValue)
        }
        .onTapGesture {
            isSelected = type
        }
        
    }
}
