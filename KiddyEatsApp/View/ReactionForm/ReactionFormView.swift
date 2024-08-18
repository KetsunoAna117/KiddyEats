//
//  ReactionFormView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 17/08/24.
//

import SwiftUI

struct ReactionFormView: View {
    let totalPages: Int = 2
    
    @State private var currentTab: Int = 0
    @State private var buttonPrompt: String = "Save reactions"
    
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                // Content
                VStack {
                    
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
                        ProgressView(value: Float(currentTab), total: Float(totalPages - 1))
                    }
                    
                })
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
            #warning("End of form logic hasn't been implemented")
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
            self.buttonPrompt = "Continue"
        case 2:
            self.buttonPrompt = "Save Reaction"
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
