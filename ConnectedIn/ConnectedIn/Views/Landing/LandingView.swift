//
//  LandingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 1/3/25.
//

import SwiftUI

struct LandingView: View {
    // MARK: - Properties
    
    @EnvironmentObject private var sessionManager: SessionManager
    let tabStore: UserTabStore
    let dashboardStore: UserDashboardViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            Image("landing_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.6)
            
            // Content
            VStack(spacing: 24) {
                Spacer()
                
                // Logo and Title
                VStack(spacing: 16) {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("ConnectedIn")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Description
                Text("Connect with your church community")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to OnboardingView
                        withAnimation(.easeInOut(duration: 0.3)) {
                            sessionManager.authState = .onboarding
                        }
                    }) {
                        Text("Learn More")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 32)
                    
                    Button(action: {
                        // Navigate to LoginView
                        sessionManager.authState = .login
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView(
            tabStore: UserTabStore(),
            dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))
        )
        .environmentObject(SessionManager())
    }
}
