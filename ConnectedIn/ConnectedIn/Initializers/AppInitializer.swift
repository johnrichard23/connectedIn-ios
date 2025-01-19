//
//  AppInitializer.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 1/3/25.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import Combine

/// Responsible for initializing the app's core services and managing the app's startup flow
@MainActor
final class AppInitializer: ObservableObject {
    // MARK: - Properties
    
    /// Indicates whether the app is still in its initialization phase
    @Published var isInitializing: Bool = true
    
    /// The session manager instance used for managing authentication state
    let sessionManager: SessionManager
    
    /// Tracks whether the app has been launched before
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    // MARK: - Constants
    
    private enum Constants {
        static let splashScreenDuration: UInt64 = 2_000_000_000 // 2 seconds
    }
    
    // MARK: - Initialization
    
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
    
    // MARK: - Public Methods
    
    /// Performs a quick initialization without splash screen
    private func quickInitialize() async {
        do {
            try await initializeAWS()
            await checkUserState()
            isInitializing = false
        } catch {
            print("❌ Quick initialization failed:", error)
            // Fallback to regular initialization if quick init fails
            initializeWithSplash()
        }
    }
    
    // MARK: - Private Methods
    
    /// Initializes the app with a splash screen for first-time launches
    private func initializeWithSplash() {
        Task {
            do {
                try await initializeAWS()
                await checkUserState()
                
                // Add a small delay for splash screen animation
                try await Task.sleep(nanoseconds: Constants.splashScreenDuration)
                isInitializing = false
                hasLaunchedBefore = true
            } catch {
                print("❌ Could not initialize Amplify: \(error)")
                if let authError = error as? AuthError {
                    print("Auth Error Details: \(authError.errorDescription)")
                    print("Recovery Suggestion: \(authError.recoverySuggestion)")
                }
                
                await checkUserState()
                isInitializing = false
                hasLaunchedBefore = true
            }
        }
    }
    
    /// Initializes AWS Amplify and its plugins
    private func initializeAWS() async throws {
        // Silent initialization for subsequent launches
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
    }
    
    /// Checks and updates the current user's authentication state
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
