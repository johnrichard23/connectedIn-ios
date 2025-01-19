//
//  ConnectedInApp.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI
import Combine

/// The main app entry point for ConnectedIn, managing the app's lifecycle and navigation flow.
@main
struct ConnectedInApp: App {
    // MARK: - Dependencies
    
    /// The shared session manager instance for handling authentication state
    @StateObject private var sessionManager: SessionManager
    
    /// View model handling authentication logic and user state
    @StateObject private var authViewModel: AuthViewModel
    
    /// Manages app initialization and startup flow
    @StateObject private var appInitializer: AppInitializer
    
    // MARK: - Persistent State
    
    /// Tracks whether the user has completed the onboarding flow
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    /// Tracks the user's login state
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    // MARK: - Initialization
    
    init() {
        // Initialize core dependencies
        let sessionManager = SessionManager()
        _sessionManager = StateObject(wrappedValue: sessionManager)
        
        // Initialize view models with dependencies
        _authViewModel = StateObject(wrappedValue: AuthViewModel(sessionManager: sessionManager))
        _appInitializer = StateObject(wrappedValue: AppInitializer(sessionManager: sessionManager))
        
        // Set the app to always use light mode
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK: - Helper Methods
    
    /// Fetches the current authenticated user
    private func getCurrentUser() {
        Task {
            await sessionManager.getCurrentAuthUser()
        }
    }
    
    // MARK: - View Body
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appInitializer.isInitializing {
                    SplashScreen(isInitializing: $appInitializer.isInitializing)
                } else {
                    Group {
                        switch sessionManager.authState {
                        case .landing:
                            LandingView(
                                tabStore: UserTabStore(),
                                dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))
                            )
                            
                        case .onboarding:
                            OnboardingView()
                            
                        case .login:
                            LoginView(
                                tabStore: UserTabStore(),
                                dashboardStore: UserDashboardViewModel(currentUser: User(email: "")),
                                viewModel: authViewModel
                            )
                            
                        case .forgotPassword:
                            ForgotPasswordView(viewModel: authViewModel)
                            
                        case .resetPassword:
                            ResetPasswordView(viewModel: authViewModel)
                            
                        case .confirmCode:
                            Text("Confirm Code View")
                            
                        case .confirmMFACode:
                            Text("MFA Code View")
                            
                        case .signUp:
                            Text("Sign Up View")
                            
                        case .sessionUser(let user), .sessionChurch(let user), .userDashboard(let user):
                            DashboardUserView(
                                tabStore: UserTabStore(),
                                dashboardStore: UserDashboardViewModel(currentUser: User(email: user.username))
                            )
                        }
                    }
                }
            }
            .environmentObject(sessionManager)
            .environmentObject(authViewModel)
            .preferredColorScheme(.light) // Force light mode at SwiftUI level
        }
    }
}
