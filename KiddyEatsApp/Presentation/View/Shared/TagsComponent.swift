//
//  TagsComponent.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct TagsComponent: View {
    let name: String
    let onTap: (String) -> ()
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.regular)
            Image(systemName: "x.circle.fill")
                .foregroundStyle(Color.gray)
                .onTapGesture {
                    onTap(name)
                }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color(uiColor: .lightGray))
        )
    }
}
