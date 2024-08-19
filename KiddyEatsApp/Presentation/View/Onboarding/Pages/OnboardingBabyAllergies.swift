//
//  OnboardingBabyAllergies.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingBabyAllergies: View {
    @Bindable var vm: BabyInformationViewModel
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
                        HStack {
                            Text("Allergens Known")
                            Spacer()
                        }
                        
                        VStack {
                            ScrollView {
                                FlexibleView(
                                    availableWidth: 310,
                                    views: renderTags()
                                )
                            }
                            .padding(20)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.primaryStrong)
                        )
                        .frame(width: 330, height: 250)
                    }
                }
                .padding(.top, 100)
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
    }
    // MARK: UIVIew to render text
    func renderTags() -> [AnyView] {
        var views: [AnyView] = []
        
        for tag in vm.allergiesList {
            views.append(
                AnyView(
                    OnboardingTagsComponent(name: tag, onTap: removeTags)
                )
            )
        }
        
        return views
    }
    
    func addTag(){
        if vm.allergiesList.contains(userInput) == false {
            vm.allergiesList.append(userInput)
            userInput.removeAll()
        }
        
    }
    
    func removeTags(name: String){
        vm.allergiesList.removeAll(where: { tag in
            tag == name
        })
    }
} 

#Preview {
    OnboardingView()
}
