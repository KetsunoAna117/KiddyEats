//
//  OnboardingBabyGender.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingBabyGender: View {
    @Bindable var vm: BabyOnboardingInformationViewModel
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Tell us your baby's gender")
                        .font(Font.system(size: 18))
                        .fontWeight(.semibold)
                    Text("How does your little one identify")
                        .fontWeight(.light)
                }
                .padding(.top, 100)
                .padding(.bottom, 30)
                
                HStack(spacing: 20) {
                    OnboardingGenderChoice(imageEmoji: "👦", type: .male, isSelected: $vm.savedbabyGender)
                    OnboardingGenderChoice(imageEmoji: "👧", type: .female, isSelected: $vm.savedbabyGender)
                }
                Spacer()
            }
        }
    }
}

 

#Preview {
    OnboardingView(onBoardingCompleted: {
        print("Onboarding Completed")
    })
}
