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
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Initialized Amplify");
        } catch {
            print("Could not initialize Amplify: \(error)")
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
