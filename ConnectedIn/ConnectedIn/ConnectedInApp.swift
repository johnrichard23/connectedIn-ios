//
//  ConnectedInApp.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct ConnectedInApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @StateObject var authViewModel = AuthViewModel()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("isLoggedIn")
    var isLoggedIn: Bool = false
    
    init() {
        // Debug code to check configuration files
        if let path = Bundle.main.path(forResource: "amplifyconfiguration", ofType: "json") {
            print("Found amplifyconfiguration.json at: \(path)")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Configuration content:")
                print(json)
            }
        } else {
            print("❌ amplifyconfiguration.json not found in bundle")
        }
        
        do {
            // First try to add the plugin
            do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                print("✅ Auth plugin added successfully")
            } catch {
                print("❌ Error adding auth plugin: \(error)")
                throw error
            }
            
            // Then try to configure Amplify
            do {
                try Amplify.configure()
                print("✅ Amplify configured successfully")
            } catch {
                print("❌ Error configuring Amplify: \(error)")
                if let authError = error as? AuthError {
                    print("Auth Error Details: \(authError.errorDescription)")
                    print("Recovery Suggestion: \(authError.recoverySuggestion ?? "No recovery suggestion available")")
                    
                    // Try to read the configuration to debug
                    if let configPath = Bundle.main.path(forResource: "awsconfiguration", ofType: "json"),
                       let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("AWS Configuration structure:")
                        if let auth = json["auth"] as? [String: Any] {
                            print("Auth configuration found")
                            if let plugins = auth["plugins"] as? [String: Any] {
                                print("Plugins found")
                                if let cognito = plugins["awsCognitoAuthPlugin"] as? [String: Any] {
                                    print("Cognito plugin configuration found")
                                    if let userPool = cognito["CognitoUserPool"] as? [String: Any] {
                                        print("User pool configuration found")
                                    } else {
                                        print("❌ No user pool configuration found")
                                    }
                                } else {
                                    print("❌ No Cognito plugin configuration found")
                                }
                            } else {
                                print("❌ No plugins configuration found")
                            }
                        } else {
                            print("❌ No auth configuration found")
                        }
                    }
                }
                throw error
            }
            
            print("✅ Amplify initialization complete")
        } catch {
            print("❌ Could not initialize Amplify: \(error)")
        }
        
        if hasSeenOnboarding {
            sessionManager.authState = .sessionUser(user: DummyUser())
            //getCurrentUser()
        } else {
            sessionManager.authState = .onboarding
        }
    }
    
    func getCurrentUser() {
        Task {
            await sessionManager.getCurrentAuthUser()
        }
    }
    
    var body: some Scene {
        WindowGroup {
                switch sessionManager.authState {
                case .onboarding:
                    LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
                case .signUp:
                    LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
                case .login:
                    LoginView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: "")), viewModel: authViewModel).environmentObject(sessionManager)
                case .forgotPassword:
                    LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
                case .userDashboard(user: let user):
                    DashboardUserView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
                case .sessionUser(user: let user):
                    DashboardUserView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
                default:
                    LandingView(tabStore: UserTabStore(), dashboardStore: UserDashboardViewModel(currentUser: User(email: ""))).environmentObject(sessionManager)
            }
        }
    }
}
