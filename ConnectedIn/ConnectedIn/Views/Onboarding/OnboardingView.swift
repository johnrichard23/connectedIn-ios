//
//  OnboardingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/3/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    @StateObject var viewModel = AuthViewModel()
    
    let pageCount: Int = 3
    
    var body: some View {
            TabView {
                OnboardingPage(title: "Connect to churches near you", subtitle: "Locate churches with a single tap.", imageName: "connectBG")
                OnboardingPage(title: "Collaborate with ministries", subtitle: "Join ministries, volunteer, and make an impact together.", imageName: "collaborateBG")
                OnboardingPage(title: "Contribute to Church Finances", subtitle: "Easily contribute to your church’s financial needs.", imageName: "contributeBG")
                LoginView(tabStore: tabStore, dashboardStore: dashboardStore, viewModel: viewModel)
                    .tabItem {
                        
                    }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .tabViewStyle(PageTabViewStyle())
    }
}
