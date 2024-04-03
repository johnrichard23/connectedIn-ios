//
//  SessionManager.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import Foundation


enum UserType {
    case admin
    case user
}

enum AuthState {
    case onboarding
    case signUp
    case login
    case forgotPassword
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .onboarding
    static let shared = SessionManager()
    var connectedInUser = User(email: "jahnrichards23@gmail.com")
    
    func getCurrentAuthUser() {
        authState = .onboarding
    }
}
