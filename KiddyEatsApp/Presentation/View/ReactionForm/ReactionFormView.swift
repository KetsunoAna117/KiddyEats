//
//  ReactionFormView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 17/08/24.
//

import SwiftUI

struct ReactionFormView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let totalPages: Int = 2
    @State private var currentTab: Int = 1
    @State private var buttonPrompt: String = "Save reactions"
    @State private var vm = ReactionLoggerViewModel(
        updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared),
        updateAllergenUseCase: UpdateBabyAllergenData(repo: BabyProfileRepositoryImpl.shared)
    )
    
    @State private var isProminentStyle: Bool = true
    
    var babyMeal: BabyMeal
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                // Content
                VStack {
                    TabView(selection: $currentTab,
                            content:  {
                        PromptTab(content: ReactionPromptView(vm: vm))
                            .tag(1)
                        PromptTab(content: ReactionEndingView(hasFilledReaction: babyMeal.hasFilledReaction))
                            .tag(2)
                    })
                    .animation(.linear, value: currentTab)
                    .onAppear {
                        vm.setupBabyMeal(selectedBabyMeal: babyMeal)
                        UIScrollView.appearance().isScrollEnabled = false
                    }
                    .onDisappear {
                        UIScrollView.appearance().isScrollEnabled = true
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    
                    if vm.reactionStatus != .unfilled {
                        if isProminentStyle {
                            Button(action: {
                                withAnimation(.linear) {
                                    goToNextPage()
                                }
                            }, label: {
                                Text(buttonPrompt)
                            })
                            .buttonStyle(KiddyEatsProminentButtonStyle())
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                        else {
                            Button(action: {
                                withAnimation(.linear) {
                                    goToNextPage()
                                }
                            }, label: {
                                Text(buttonPrompt)
                            })
                            .buttonStyle(KiddyEatsBorderedButtonStyle())
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                    }
                    
                }
                
                // Progress bar
                Button(action: {
                    withAnimation(.easeInOut) {
                        goToPreviousPage()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .padding(.trailing, 20)
                        ProgressView(value: Float(currentTab), total: Float(totalPages))
                    }
                    
                })
                .padding(.horizontal, 30)
            }
        }
        .onAppear(){
            if babyMeal.hasFilledReaction {
                if babyMeal.reactionList.isEmpty {
                    vm.reactionStatus = .noReaction
					vm.reactionDetails = []
                }
                else {
                    vm.reactionStatus = .hadReaction
                    vm.reactionDetails = babyMeal.reactionList.compactMap { rawString in
                        ReactionDetails(rawValue: rawString)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: Below are UI Functions to modify the view
    func goToNextPage(){
        if currentTab < totalPages {
            currentTab += 1
            changeButtonPrompt()
        }
        else {
            vm.updateBabyMealReaction(modelContext: modelContext)
            dismiss()
            UIScrollView.appearance().isScrollEnabled = true
        }
    }
    
    func goToPreviousPage(){
        if currentTab - 1 > 0 {
            currentTab -= 1
            changeButtonPrompt()
            
        }
        else {
            dismiss()
            UIScrollView.appearance().isScrollEnabled = true
        }
    }
    
    func changeButtonPrompt(){
        switch currentTab {
        case 1:
            self.buttonPrompt = "Save Reaction"
        case 2:
            self.buttonPrompt = "Finish"
        default:
            self.buttonPrompt = ""
        }
        
    }
}

private struct PromptTab<Content: View>: View {
    let content: Content
    
    var body: some View {
        VStack {
            content
                .transition(.slide)
        }
    }
}
