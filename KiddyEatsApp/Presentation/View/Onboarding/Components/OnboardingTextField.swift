//
//  OnboardingTextField.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingTextField: View {
    var title: String?
    var placeholder: String?
    @Binding var content: String
    
    @FocusState private var isTapped: Bool
    
    var body: some View {
        VStack {
            if let title = title {
                HStack {
                    Text(title)
                    Spacer()
                }
            }
            
            ZStack {
                TextField(text: $content) {
                    if let placeholder = placeholder {
                        Text(placeholder)
                    }
                }
                .padding()
                .onSubmit {
                    isTapped = true
                }
                .focused($isTapped)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.white)
            )
        }
    }
}

#Preview {
    OnboardingTextField(title: nil, placeholder: "\"Peanuts\"" ,content: .constant(""))
}
