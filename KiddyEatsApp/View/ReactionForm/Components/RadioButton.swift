//
//  RadioButton.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct RadioButton<SelectionType: Hashable & Equatable>: View {
    let text: String
    @Binding var selection: SelectionType
    let tags: SelectionType
    
    var body: some View {
        HStack {
            Group {
                if selection == tags {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                    }
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            Text(text)
        }
        .onTapGesture {
            selection = tags
        }
    }
}


#Preview {
    RadioButton(text: "Yes, had reaction", selection: .constant(ReactionStatus.hadReaction), tags: ReactionStatus.noReaction)
}
