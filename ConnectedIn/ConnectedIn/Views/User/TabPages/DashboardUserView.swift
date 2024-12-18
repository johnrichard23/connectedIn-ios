//
//  DashboardUserView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/19/24.
//

import SwiftUI

struct DashboardUserView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    
    @State private var selectedTab = 0
    @State private var isDetailsViewHidden = false
    
    @State private var churches: [Church] = []
    @State private var missionaries: [Missionary] = []
    @State private var ministries: [Ministry] = []
    
    var pages = [UserTabBarPage(icon: "homeIcon", tag: .home, text: "Home"),
                 UserTabBarPage(icon: "connectIcon", tag: .connect, text: "Connect"),
                 UserTabBarPage(icon: "contributeIcon", tag: .contribute, text: "Contribute"),
                 UserTabBarPage(icon: "settingsIcon", tag: .profile, text: "Profile"),]
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $selectedTab) {
                    HomeView(tabStore: tabStore, dashboardStore: dashboardStore, isButtonTapped: $isDetailsViewHidden).environmentObject(sessionManager)
                        .tabItem {
                            Image("homeIcon")
                                .frame(width: 20, height: 20)
                            Text("Home")
                        }
                        .badge(3)
                        .tag(0)
                    
                    ConnectView()
                        .tabItem() {
                            Image("connectIcon")
                                .frame(width: 20, height: 20)
                            Text("Connect")
                        }
                        .tag(1)
                    
                    ContributionView(
                        churches: churches,
                        missionaries: missionaries,
                        ministries: ministries
                    )
                        .tabItem() {
                            Image("contributeIcon")
                                .frame(width: 20, height: 20)
                            Text("Contribute")
                        }
                        .tag(2)
                    
                    HomeView(tabStore: tabStore, dashboardStore: dashboardStore, isButtonTapped: $isDetailsViewHidden).environmentObject(sessionManager)
                        .tabItem() {
                            Image("settingsIcon")
                                .frame(width: 20, height: 20)
                            Text("My Profile")
                        }
                        .tag(3)
                }
                .background(Color.white.ignoresSafeArea(edges: .all))
            }
        }
        .onAppear {
            setupTabBar()
        }
    }
}

extension DashboardUserView {
    
    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.white)
        appearance.shadowColor = UIColor(Color.black)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color.white)
        itemAppearance.selected.iconColor = UIColor(Color.red)
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isHidden  = false
    }
}
