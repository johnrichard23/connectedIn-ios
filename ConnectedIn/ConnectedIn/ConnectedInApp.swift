//
//  ConnectedInApp.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import Combine

@MainActor
final class AppInitializer: ObservableObject {
    @Published var isInitializing: Bool = true
    let sessionManager: SessionManager
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        // Skip initialization animation if not first launch
        if hasLaunchedBefore {
            Task {
                await quickInitialize()
            }
        } else {
            initializeWithSplash()
        }
    }
    
    private func quickInitialize() async {
        do {
            try await initializeAWSQuietly()
            await checkUserState()
            isInitializing = false
        } catch {
            print("❌ Quick initialization failed:", error)
            // Fallback to regular initialization if quick init fails
            initializeWithSplash()
        }
    }
    
    private func initializeWithSplash() {
        Task {
            do {
                try await initializeAWSQuietly()
                await checkUserState()
                
                // Add a small delay for splash screen animation
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                isInitializing = false
                hasLaunchedBefore = true
            } catch {
                print("❌ Could not initialize Amplify: \(error)")
                if let authError = error as? AuthError {
                    print("Auth Error Details: \(authError.errorDescription)")
                    print("Recovery Suggestion: \(authError.recoverySuggestion ?? "No recovery suggestion available")")
                }
                
                await checkUserState()
                isInitializing = false
                hasLaunchedBefore = true
            }
        }
    }
    
    private func initializeAWSQuietly() async throws {
        // Silent initialization for subsequent launches
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
    }
    
    private func checkUserState() async {
        do {
            // First check if we have an active session
            let session = try await Amplify.Auth.fetchAuthSession()
            
            if session.isSignedIn {
                print("✅ Active session found, getting current user")
                await self.sessionManager.getCurrentAuthUser()
            } else {
                print("❌ No active session")
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    self.sessionManager.authState = .login
                } else {
                    self.sessionManager.authState = .onboarding
                }
            }
        } catch {
            print("❌ Error checking session:", error)
            if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                self.sessionManager.authState = .login
            } else {
                self.sessionManager.authState = .onboarding
            }
        }
    }
}

@main
struct ConnectedInApp: App {
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var authViewModel: AuthViewModel
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject private var appInitializer: AppInitializer
    
    init() {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(sessionManager: SessionManager.shared))
        _appInitializer = StateObject(wrappedValue: AppInitializer(sessionManager: SessionManager.shared))
        _sessionManager = StateObject(wrappedValue: SessionManager.shared)
    }
    
    func getCurrentUser() {
        Task {
            await sessionManager.getCurrentAuthUser()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appInitializer.isInitializing {
                    SplashScreen()
                } else {
                    switch sessionManager.authState {
                    case .onboarding:
                        LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: "")))
                            .environmentObject(sessionManager)
                    case .signUp:
                        LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: "")))
                            .environmentObject(sessionManager)
                    case .login:
                        LoginView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: "")), viewModel: authViewModel)
                            .environmentObject(sessionManager)
                    case .forgotPassword:
                        ForgotPasswordView(viewModel: authViewModel)
                            .environmentObject(sessionManager)
                    case .resetPassword:
                        ResetPasswordView(viewModel: authViewModel)
                            .environmentObject(sessionManager)
                    case .confirmCode(username: let username):
                        Text("Confirm Code")
                            .environmentObject(sessionManager)
                    case .confirmMFACode:
                        Text("MFA Code")
                            .environmentObject(sessionManager)
                    case .sessionUser(let user):
                        DashboardUserView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: user.username)))
                            .environmentObject(sessionManager)
                    case .sessionChurch(let user):
                        DashboardUserView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: user.username)))
                            .environmentObject(sessionManager)
                    case .userDashboard(let user):
                        DashboardUserView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: user.username)))
                            .environmentObject(sessionManager)
                    }
                }
            }
        }
    }
}
