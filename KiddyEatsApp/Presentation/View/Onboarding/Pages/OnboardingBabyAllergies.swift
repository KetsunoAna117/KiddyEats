//
//  OnboardingBabyAllergies.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingBabyAllergies: View {
    @Bindable var vm: BabyOnboardingInformationViewModel
    @State private var userInput = ""
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    VStack {
                        Text("Tell us about your baby's allergies")
                            .font(Font.system(size: 18))
                            .fontWeight(.semibold)
                        Text("Any allergies we should know about? (You can skip this and update it later)")
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)
                    
                    VStack(alignment: .leading) {
                        OnboardingTextField(placeholder: "\"Peanuts\"", content: $userInput)
                            .onSubmit {
                                addTag()
                            }
                        Text("Enter your allergen and press Enter to add it. You can add more than one.")
                            .font(Font.system(size: 12))
                            .fontWeight(.light)
                    }
                    .padding(.bottom, 30)
                    
                    VStack {
                        OnboardingAllergenList(
                            title: "Allergens Known",
                            tagList: $vm.savedallergiesList,
                            removeTag: removeTags
                        )
                    }
                }
                .padding(.top, 100)
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
    }
    
    func addTag(){
        if vm.savedallergiesList.contains(userInput) == false {
            vm.savedallergiesList.append(userInput)
            userInput.removeAll()
        }
        
    }
    
    func removeTags(name: String){
        vm.savedallergiesList.removeAll(where: { tag in
            tag == name
        })
    }
} 

#Preview {
    OnboardingView(onBoardingCompleted: {
        print("Onboarding Completed")
    })
}
