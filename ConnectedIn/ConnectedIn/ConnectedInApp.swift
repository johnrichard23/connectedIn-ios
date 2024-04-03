//
//  ConnectedInApp.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI

@main
struct ConnectedInApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        sessionManager.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            
            switch sessionManager.authState {
            case .onboarding:
                LandingView().environmentObject(sessionManager)
            case .signUp:
                LandingView().environmentObject(sessionManager)
            case .login:
                LandingView().environmentObject(sessionManager)
            case .forgotPassword:
                LandingView().environmentObject(sessionManager)
            }
        }
    }
}
