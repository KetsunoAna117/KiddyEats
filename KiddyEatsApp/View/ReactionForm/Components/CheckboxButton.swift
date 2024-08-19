//
//  CheckboxButton.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct CheckboxButton<SelectionType: Hashable & Equatable>: View {
    let text: String
    @Binding var selectionList: [SelectionType]
    let tags: SelectionType
    
    var body: some View {
        HStack {
            Group {
                if selectionList.contains(tags) {
                    ZStack {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 20, height: 20)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.white)
                            }
                    }
                } else {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            Text(text)
        }
        .onTapGesture {
            if selectionList.contains(tags) {
                selectionList.removeAll { tag in
                    tag == tags
                }
            }
            else {
                selectionList.append(tags)
            }
        }
    }
}

#Preview {
    ReactionChooseListView(vm: ReactionLoggerViewModel(), previousState: .constant(.unfilled))
}
