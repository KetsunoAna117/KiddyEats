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
        VStack(alignment: .leading) {
            Section {
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
            } header: {
                if let title = title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.greenPrimary)
                }
            }
            
        }
    }
}

#Preview {
    OnboardingTextField(title: nil, placeholder: "\"Peanuts\"" ,content: .constant(""))
}
