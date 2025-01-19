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

/// AppInitializer is responsible for managing the app's initialization process,
/// including AWS configuration, authentication state restoration, and splash screen handling.
@MainActor
final class AppInitializer: ObservableObject {
    
    // MARK: - Properties
    
    /// Indicates whether the app is currently in its initialization phase
    @Published var isInitializing: Bool = true
    
    /// The session manager instance used for managing authentication state
    private let sessionManager: SessionManager
    
    /// Tracks whether the app has been launched before for splash screen handling
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    // MARK: - Constants
    
    private enum Constants {
        /// Duration to show the splash screen (2 seconds)
        static let splashScreenDuration: UInt64 = 2_000_000_000
        
        /// Keys for UserDefaults
        enum UserDefaultsKeys {
            static let hasSeenOnboarding = "hasSeenOnboarding"
        }
        
        /// Log messages for better debugging
        enum LogMessages {
            static let quickInitFailed = "❌ Quick initialization failed:"
            static let amplifyInitFailed = "❌ Could not initialize Amplify:"
            static let sessionCheckFailed = "❌ Error checking session:"
            static let activeSessionFound = "✅ Active session found, getting current user"
            static let noActiveSession = "❌ No active session"
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes the AppInitializer with required dependencies
    /// - Parameter sessionManager: The session manager instance to be used
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        // Determine initialization path based on previous launches
        if hasLaunchedBefore {
            Task {
                await quickInitialize()
            }
        } else {
            initializeWithSplash()
        }
    }
    
    // MARK: - Private Methods
    
    /// Performs a quick initialization without splash screen for subsequent launches
    private func quickInitialize() async {
        do {
            try await initializeAWS()
            await checkUserState()
            isInitializing = false
        } catch {
            print(Constants.LogMessages.quickInitFailed, error)
            // Fallback to regular initialization if quick init fails
            initializeWithSplash()
        }
    }
    
    /// Initializes the app with a splash screen for first-time launches
    private func initializeWithSplash() {
        Task {
            do {
                try await initializeAWS()
                await checkUserState()
                
                // Add a small delay for splash screen animation
                try await Task.sleep(nanoseconds: Constants.splashScreenDuration)
                
                await MainActor.run {
                    isInitializing = false
                    hasLaunchedBefore = true
                }
            } catch {
                print(Constants.LogMessages.amplifyInitFailed, error)
                
                if let authError = error as? AuthError {
                    print("Auth Error Details: \(authError.errorDescription)")
                    print("Recovery Suggestion: \(authError.recoverySuggestion)")
                }
                
                await checkUserState()
                
                await MainActor.run {
                    isInitializing = false
                    hasLaunchedBefore = true
                }
            }
        }
    }
    
    /// Initializes AWS Amplify and its plugins
    private func initializeAWS() async throws {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
    }
    
    /// Checks and updates the current user's authentication state
    private func checkUserState() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            
            await MainActor.run {
                if session.isSignedIn {
                    print(Constants.LogMessages.activeSessionFound)
                    Task {
                        await self.sessionManager.getCurrentAuthUser()
                    }
                } else {
                    print(Constants.LogMessages.noActiveSession)
                    // Show LandingView first
                    self.sessionManager.authState = .landing
                }
            }
        } catch {
            print(Constants.LogMessages.sessionCheckFailed, error)
            
            await MainActor.run {
                // Show LandingView first
                self.sessionManager.authState = .landing
            }
        }
    }
}
