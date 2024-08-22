//
//  ReactionEndingView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 18/08/24.
//

import SwiftUI

struct ReactionEndingView: View {
    let hasFilledReaction: Bool
    
    var body: some View {
        VStack {
            Text("👏")
                .font(Font.system(size: 80))
                .padding(.bottom, 20)
            
            if hasFilledReaction == false {
                Text("You’ve done great, Mama!")
                    .fontWeight(.bold)
                    .font(.title)
                
                Text("You’ve logged a potential allergy reaction. Don’t worry, we won’t include the ingredients in our future recommendations.")
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
            }
            else {
                Text("Thank You!")
                    .fontWeight(.bold)
                    .font(.title)
                
                Text("You’re helping us refining our future recommendations for Sophie.")
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
            }
            
            
            
        }
        
    }
}
