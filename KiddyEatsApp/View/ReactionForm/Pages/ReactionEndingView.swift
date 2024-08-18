//
//  ReactionEndingView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct ReactionEndingView: View {
    var body: some View {
        VStack {
            Text("👏")
                .font(Font.system(size: 80))
                .padding(.bottom, 20)
            Text("Great Job!")
                .fontWeight(.bold)
                .font(.title)
            
            Text("You’ve logged a potential allergy reaction, helping us keep track of ingredients to watch out for in future meals.")
                .multilineTextAlignment(.center)
                .frame(width: 300)
        }
        
    }
}

#Preview {
    ReactionEndingView()
}
