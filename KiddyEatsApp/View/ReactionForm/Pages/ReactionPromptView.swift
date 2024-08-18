//
//  ReactionPromptView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct ReactionPromptView: View {
    @State var vm = ReactionLoggerViewModel()
    @State var reactionPromptIsPresented = false
    
    var body: some View {
        VStack {
            Text("Did your baby experience any reaction?")
                .fontWeight(.bold)
                .frame(width: 300)
                .multilineTextAlignment(.center)
            
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
        }
        .sheet(
            isPresented: $reactionPromptIsPresented,
            onDismiss: {
                if vm.reactionDetails.isEmpty {
                    vm.reactionStatus = .noReaction
                }
            },
            content: {
                ReactionChooseListView(vm: vm)
                    .presentationDetents([.height(500)])
            })
        .onChange(of: vm.reactionStatus) { oldValue, newValue in
            if newValue == .hadReaction {
                self.reactionPromptIsPresented = true
            }
            else {
                self.reactionPromptIsPresented = false
            }
        }
    }
}

#Preview {
    ReactionPromptView()
}
