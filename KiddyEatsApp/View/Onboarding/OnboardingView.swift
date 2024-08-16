//
//  OnboardingView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingView: View {
    let totalPages = 4
    @State var vm = BabyInformationViewModel()
    @State private var currentTab: Int = 0
    @State private var buttonPrompt: String = "Personalize for your baby"
    
    var body: some View {
        ZStack {
            if currentTab == 0 {
                Color.primaryStrong.ignoresSafeArea()
            } else {
                Color.appBackground.ignoresSafeArea()
            }
            ZStack(alignment: .top) {
                VStack {
                    TabView(selection: $currentTab,
                            content:  {
                        OnboardingTab(content: StartingOnboardingView())
                            .tag(0)
                        OnboardingTab(content: OnboardingBabyInfo(vm: vm))
                            .tag(1)
                        OnboardingTab(content: OnboardingBabyGender(vm: vm))
                            .tag(2)
                        OnboardingTab(content: OnboardingBabyAllergies(vm: vm))
                            .tag(3)
                    })
                    .animation(.linear, value: currentTab)
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = false
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            goToNextPage()
                        }
                        
                    }, label: {
                        Text(buttonPrompt)
                            .font(Font.system(size: 15))
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    })
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                
                if currentTab > 0 {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            goToPreviousPage()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .padding(.trailing, 20)
                            ProgressView(value: Float(currentTab), total: Float(totalPages - 1))
                        }
                        
                    })
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    // MARK: Below are UI Functions to modify the view
    func goToNextPage(){
        if currentTab < totalPages - 1 {
            currentTab += 1
            changeButtonPrompt()
        }
        else {
            print("End of tab")
            #warning("End of onboarding logic hasn't been implemented")
        }
    }
    
    func goToPreviousPage(){
        if currentTab > 0 {
            currentTab -= 1
            changeButtonPrompt()
            print("Button pressed")
        }
    }
    
    func changeButtonPrompt(){
        switch currentTab {
        case 0:
            self.buttonPrompt = "Personalize for your baby"
        case 1...2:
            self.buttonPrompt = "Continue"
        case 3:
            self.buttonPrompt = "Let's start cooking"
        default:
            self.buttonPrompt = ""
        }
        
    }
}

private struct OnboardingTab<Content: View>: View {
    let content: Content
    
    var body: some View {
        VStack {
            content
                .transition(.slide)
        }
    }
}

#Preview {
    OnboardingView()
}
