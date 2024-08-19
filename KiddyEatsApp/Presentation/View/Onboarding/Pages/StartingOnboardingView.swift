//
//  StartingOnboardingView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct StartingOnboardingView: View {
    var body: some View {
        ZStack {
            Color.primaryStrong
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    VStack {
                        Text("Safe from allergens,")
                            .font(Font.system(size: 32))
                            .multilineTextAlignment(.center)
                        Text("tailored for you.")
                            .font(Font.system(size: 32))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 300)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                    
                    Text("Discover safe, delicious recipes with personalized recommendations while we help identify potential allergens in every meal.")
                        .font(Font.system(size: 14))
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                    
                    Image(.onBoardingCharacter)
                        .resizable()
                        .frame(width: 280, height: 280)
                        .aspectRatio(contentMode: .fill)
                    
                }
                .padding(.top, 100)
                .foregroundStyle(.accent)
                
                Spacer()
            }
        }
    }
}

#Preview {
    StartingOnboardingView()
}
