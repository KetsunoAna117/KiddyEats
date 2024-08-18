//
//  ReactionChooseListView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct ReactionChooseListView: View {
    @Environment (\.dismiss) var dismiss
    @Bindable var vm: ReactionLoggerViewModel
    @State var selectionList: [ReactionDetails] = []
    
    var body: some View {
        ScrollView {
            VStack {
                Text("To help us track your baby’s health, please select any reactions your baby experienced from the list below.")
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    ForEach(ReactionDetails.allCases, id: \.self) { reaction in
                        if reaction != .none {
                            CheckboxButton(
                                text: reaction.rawValue,
                                selectionList: $selectionList,
                                tags: reaction
                            )
                        }
                        
                    }
                })
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Button(action: {
                    vm.reactionDetails = selectionList
                    dismiss()
                }, label: {
                    Text("Save Reactions")
                })
                .padding(.horizontal, 30)
                .buttonStyle(KiddyEatsProminentButtonStyle())
                
                Button(action: {
                    selectionList = []
                }, label: {
                    Text("Clear All")
                })
                .buttonStyle(KiddyEatsBorderlessButtonStyle())
                .padding(.horizontal, 30)
            }
        }
        .onAppear {
            selectionList = vm.reactionDetails
        }
        .padding(.top, 30)
        
    }
}

#Preview {
    ReactionChooseListView(vm: ReactionLoggerViewModel())
}
