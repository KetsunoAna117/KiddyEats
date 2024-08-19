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
