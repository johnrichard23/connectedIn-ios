import Foundation
import Amplify
@testable import ConnectedIn

class MockAmplifyAuth: AuthCategoryBehavior {
    var shouldSucceed: Bool = true
    var nextStep: AuthSignInStep = .done
    var isSignedIn: Bool = true
    var error: AuthError?
    
    func signIn(username: String, password: String, options: AuthSignInRequest.Options?) async throws -> AuthSignInResult {
        if let error = error {
            throw error
        }
        
        if shouldSucceed {
            return AuthSignInResult(nextStep: nextStep, isSignedIn: isSignedIn)
        } else {
            throw AuthError.service("Invalid credentials", "Please check your email and password", nil)
        }
    }
    
    func fetchAuthSession(options: AuthFetchSessionRequest.Options?) async throws -> AuthSession {
        if shouldSucceed {
            return MockAuthSession(isSignedIn: isSignedIn)
        } else {
            throw AuthError.sessionExpired("Session has expired", "Please sign in again", nil)
        }
    }
    
    func getCurrentUser() async throws -> AuthUser {
        if shouldSucceed {
            return MockAuthUser(userId: "test-user-id", username: "test@example.com")
        } else {
            throw AuthError.signedOut("User is not signed in", "Please sign in", nil)
        }
    }
    
    // Implement other required methods with default implementations
    func signUp(username: String, password: String?, options: AuthSignUpRequest.Options?) async throws -> AuthSignUpResult {
        fatalError("Not implemented")
    }
    
    func confirmSignUp(for username: String, confirmationCode: String, options: AuthConfirmSignUpRequest.Options?) async throws -> AuthSignUpResult {
        fatalError("Not implemented")
    }
    
    func resetPassword(for username: String, options: AuthResetPasswordRequest.Options?) async throws -> AuthResetPasswordResult {
        fatalError("Not implemented")
    }
    
    func confirmResetPassword(for username: String, with newPassword: String, confirmationCode: String, options: AuthConfirmResetPasswordRequest.Options?) async throws {
        fatalError("Not implemented")
    }
    
    func signOut(options: AuthSignOutRequest.Options?) async throws {
        fatalError("Not implemented")
    }
    
    func deleteUser() async throws {
        fatalError("Not implemented")
    }
}

struct MockAuthSession: AuthSession {
    let isSignedIn: Bool
    
    func invalidate() { }
}

struct MockAuthUser: AuthUser {
    let userId: String
    let username: String
}
