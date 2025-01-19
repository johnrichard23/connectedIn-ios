import SwiftUI
import Amplify

class SessionManager: ObservableObject {
    enum AuthState: Equatable {
        case onboarding
        case signUp
        case login
        case forgotPassword
        case resetPassword
        case confirmCode(username: String)
        case confirmMFACode
        case userDashboard(user: AuthUser)
        case sessionUser(user: AuthUser)
        case sessionChurch(user: AuthUser)
        
        static func == (lhs: AuthState, rhs: AuthState) -> Bool {
            switch (lhs, rhs) {
            case (.onboarding, .onboarding),
                (.signUp, .signUp),
                (.login, .login),
                (.forgotPassword, .forgotPassword),
                (.resetPassword, .resetPassword),
                (.confirmMFACode, .confirmMFACode):
                return true
            case (.confirmCode(let lhsUsername), .confirmCode(let rhsUsername)):
                return lhsUsername == rhsUsername
            case (.userDashboard(let lhsUser), .userDashboard(let rhsUser)):
                return lhsUser.userId == rhsUser.userId
            case (.sessionUser(let lhsUser), .sessionUser(let rhsUser)):
                return lhsUser.userId == rhsUser.userId
            case (.sessionChurch(let lhsUser), .sessionChurch(let rhsUser)):
                return lhsUser.userId == rhsUser.userId
            default:
                return false
            }
        }
    }
    
    @Published var authState: AuthState = .onboarding
    @Published var connectedInUser: User?
    @Published var currentEmail: String = ""
    weak var authViewModel: AuthViewModel?
    
    init() {
        // Initialize with default state
        if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            self.authState = .login
        } else {
            self.authState = .onboarding
        }
    }
    
    func showLogin() {
        print("➡️ Showing login view")
        authState = .login
    }
    
    func showForgotPassword() {
        print("➡️ Showing forgot password view")
        authState = .forgotPassword
    }
    
    func showResetPassword() {
        print("➡️ Showing reset password view")
        authState = .resetPassword
    }
    
    func showDashboard(user: AuthUser) {
        print("➡️ Showing dashboard for user: \(user.userId)")
        authState = .sessionUser(user: user)
    }
    
    func signOut() {
        Task {
            do {
                try await Amplify.Auth.signOut()
                await MainActor.run {
                    print("➡️ Signed out, showing login view")
                    authState = .login
                }
            } catch {
                print("❌ Error signing out: \(error)")
            }
        }
    }
    
    func getCurrentAuthUser() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn {
                let user = try await Amplify.Auth.getCurrentUser()
                await MainActor.run {
                    print("➡️ Found current user, showing dashboard")
                    authState = .sessionUser(user: user)
                }
            }
        } catch {
            print("❌ Error getting current user: \(error)")
        }
    }
}
