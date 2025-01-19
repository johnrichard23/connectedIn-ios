//
//  LandingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI

struct LandingView: View {
    // MARK: - Properties
    
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    
    @State private var showingAlert = false
    @State private var navigateToOnboarding = false
    @State var alertMessage: String = ""
    @State var landingScreenBG: String = "landingScreenBG"
    @State var connectedInLogo: String = "connectedInLogo2"
    @State var getStartedButton: String = "getStartedButton"
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            Image(landingScreenBG)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Logo
            VStack {
                Spacer()
                Image(connectedInLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 550)
                    .padding(.horizontal, 40)
                    .opacity(0.7)
                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
            }
            
            // Tagline
            VStack {
                Text("Connect. Collaborate. Contribute.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.bottom, 230)
                    .textCase(.uppercase)
                    .tracking(1.6)
                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                    .padding(.vertical, 100)
            }
            
            // Button
            VStack(alignment: .leading) {
                Spacer()
                Button(action: {
                    print("Learn More button tapped")
                    Task { @MainActor in
                        sessionManager.showOnboarding()
                        navigateToOnboarding = true
                        print("LandingView: Changed state to onboarding")
                    }
                }) {
                    Text("Learn more")
                        .foregroundColor(.white)
                        .padding(.horizontal, 115)
                        .padding(.vertical, 20)
                        .background(Color.connectedInMain)
                        .cornerRadius(12)
                        .font(.system(size: 16, weight: .regular))
                        .textCase(.uppercase)
                        .tracking(1.0)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                }
            }
            .padding(.vertical, 75)
        }
        .navigationDestination(isPresented: $navigateToOnboarding) {
            OnboardingView()
        }
        .onAppear {
            print("LandingView appeared with auth state: \(sessionManager.authState)")
        }
    }
}
