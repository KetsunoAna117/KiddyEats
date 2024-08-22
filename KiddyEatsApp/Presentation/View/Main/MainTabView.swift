//
//  MainTabView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.modelContext) var modelContext
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @State var vm = BabyGlobalConfigurationViewModel(
        babyDataFetcherUseCase: GetBabyProfileData(repo: BabyProfileRepositoryImpl.shared)
    )
    
    var body: some View {
        VStack {
            if isOnboardingCompleted {
                if let baby = vm.babyProfile {
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
                            ProfileView()
                        }
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                    }
                    
                    .onAppear(){
                        print("Baby data detected: \(baby)")
                    }
                }
            }
            else {
                OnboardingView(onBoardingCompleted: {
                    isOnboardingCompleted = true
                    vm.getBabyProfileData(modelContext: modelContext)
                })
            }
        }
        .onAppear(){
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .appBackground // Set your desired color here
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            vm.getBabyProfileData(modelContext: modelContext)
            if vm.babyProfile == nil {
                self.isOnboardingCompleted = false
            }
        }
    }
}


#Preview {
    MainTabView()
}
