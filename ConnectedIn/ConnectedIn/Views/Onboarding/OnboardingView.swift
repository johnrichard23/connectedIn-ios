//
//  OnboardingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/3/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    
    let pageCount: Int = 3
    
    var body: some View {
            TabView {
                OnboardingPage(title: "Connect", subtitle: "and communicate with the local church", imageName: "collaborateBG")
                OnboardingPage(title: "Collaborate", subtitle: "in church projects, mission trips, and mission endeavors", imageName: "collaborateBG")
                OnboardingPage(title: "Contribute", subtitle: "in the church's ministry through financial support", imageName: "contributeBG")
                LoginView()
                    .tabItem {
                        
                    }
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    OnboardingView()
}
