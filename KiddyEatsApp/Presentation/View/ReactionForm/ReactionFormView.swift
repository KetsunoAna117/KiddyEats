//
//  ReactionFormView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 17/08/24.
//

import SwiftUI

struct ReactionFormView: View {
    let totalPages: Int = 2
    @State private var currentTab: Int = 1
    @State private var buttonPrompt: String = "Save reactions"
    @State private var vm = ReactionLoggerViewModel(
        updateReactionUseCase: UpdateBabyMealReactionUseCase(repo: BabyMealRepositoryImpl.shared)
    )
    
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
                        PromptTab(content: ReactionEndingView())
                            .tag(2)
                    })
                    .animation(.linear, value: currentTab)
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = false
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    
                    if vm.reactionStatus != .unfilled {
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
    }
    
    // MARK: Below are UI Functions to modify the view
    func goToNextPage(){
        if currentTab < totalPages {
            currentTab += 1
            changeButtonPrompt()
        }
        else {
            #warning("End of form logic hasn't been implemented")
        }
    }
    
    func goToPreviousPage(){
        if currentTab - 1 > 0 {
            currentTab -= 1
            changeButtonPrompt()
            
        }
        else {
            #warning("Go back logic from this view hasn't been implemented")
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

#Preview {
    ReactionFormView()
}
