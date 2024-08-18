//
//  ReactionPromptView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct ReactionPromptView: View {
    @Bindable var vm: ReactionLoggerViewModel
    @State var reactionPromptIsPresented = false
    @State var previousState = ReactionStatus.unfilled
    
    var body: some View {
        VStack {
            Text("Did your baby experience any reaction?")
                .fontWeight(.bold)
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                RadioButton(
                    text: "Yes, Had reactions",
                    selection: $vm.reactionStatus,
                    tags: ReactionStatus.hadReaction
                )
                
                RadioButton(
                    text: "No, Everything's fine",
                    selection: $vm.reactionStatus,
                    tags: ReactionStatus.noReaction
                )
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .sheet(
            isPresented: $reactionPromptIsPresented,
            onDismiss: {
                vm.reactionStatus = previousState
            },
            content: {
                ReactionChooseListView(vm: vm, previousState: $previousState)
                    .presentationDetents([.height(500)])
            })
        .onChange(of: vm.reactionStatus) { oldValue, newValue in
            if newValue == .hadReaction {
                self.reactionPromptIsPresented = true
            }
            else {
                self.reactionPromptIsPresented = false
            }
            
            if newValue == .noReaction {
                self.previousState = .noReaction
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 100)
    }
}

#Preview {
    ReactionPromptView(vm: ReactionLoggerViewModel())
}
