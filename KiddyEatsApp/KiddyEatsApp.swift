//
//  KiddyEatsAppApp.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 15/08/24.
//

import SwiftUI

@main
struct KiddyEatsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass.circle")
            }
            
            NavigationView {
                Text("Hello")
            }
            .tabItem {
                Label("Collections", systemImage: "heart.circle")
            }
            
            NavigationView {
                Text("Hello")
            }
            .tabItem {
                Label("Log", systemImage: "pencil.circle")
            }
            
            NavigationView {
                Text("Hello")
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
