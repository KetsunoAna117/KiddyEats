//
//  OnboardingAllergenList.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 21/08/24.
//

import SwiftUI

struct KiddyEatsAllergenList: View {
    var title: String?
    @Binding var tagList: [String]
    var removeTag: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                VStack {
                    ScrollView {
                        FlexibleView(
                            availableWidth: 310,
                            views: renderTags()
                        )
                    }
                    .padding(20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.primaryStrong)
                )
                .frame(height: 250)
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
    
    // MARK: UIVIew to render text
    func renderTags() -> [AnyView] {
        var views: [AnyView] = []
        
        for tag in tagList {
            views.append(
                AnyView(
                    TagsComponent(name: tag, onTap: removeTag)
                )
            )
        }
        
        return views
    }
}
