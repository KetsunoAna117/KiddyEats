//
//  ErrorContainer.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 20/08/24.
//

import SwiftUI

struct ErrorContainer: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .cornerRadius(10)
    }
}
