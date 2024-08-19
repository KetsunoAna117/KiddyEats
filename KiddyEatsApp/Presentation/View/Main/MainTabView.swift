//
//  MainTabView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass.circle")
            }
            
            NavigationStack {
                CollectionView()
            }
            .tabItem {
                Label("Collections", systemImage: "heart.circle")
            }
            
            NavigationStack {
                Text("Hello")
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
        .environment(ExploreViewModel())
    }
}


#Preview {
    MainTabView()
}
