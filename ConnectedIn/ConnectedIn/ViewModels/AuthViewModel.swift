//
//  AuthViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 9/25/24.
//

import Foundation
import Amplify
import Combine
import AWSCognitoAuthPlugin
import AmplifyPlugins

@MainActor
class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private var signInResult: AuthSignInResult?
    private let sessionManager: SessionManager
    
    var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        sessionManager.authViewModel = self
    }
    
    func handleSuccessfulAuthentication() async {
        do {
            let cognitoUser = try await Amplify.Auth.getCurrentUser()
            print("✅ Got current user: \(cognitoUser.userId)")
            
            // Create and save user to UserDefaults
            var connectedInUser = User(email: cognitoUser.username)
            connectedInUser.userID = Int(cognitoUser.userId) ?? 0
            connectedInUser.role = UserRole(id: 1, email: cognitoUser.username, role: "user")
            UserDefaultsManager.shared.saveConnectedInUser(user: connectedInUser)
            
            print("✅ Setting session state to .sessionUser")
            await MainActor.run {
                sessionManager.connectedInUser = connectedInUser
                sessionManager.currentEmail = cognitoUser.username
                sessionManager.authState = .sessionUser(user: cognitoUser)
                isAuthenticated = true
            }
            print("✅ Current session state: \(sessionManager.authState)")
        } catch {
            print("❌ Error getting current user: \(error)")
            await MainActor.run {
                errorMessage = error.localizedDescription
                isAuthenticated = false
            }
        }
    }
    
    func login(username: String, password: String) async {
        do {
            let result = try await Amplify.Auth.signIn(username: username, password: password)
            print("✅ Sign in result: \(result.isSignedIn)")
            signInResult = result
            
            switch result.nextStep {
            case .confirmSignUp:
                print("➡️ Need to confirm signup")
                sessionManager.authState = .confirmCode(username: username)
            case .confirmSignInWithSMSMFACode:
                print("➡️ Need to confirm MFA")
                sessionManager.authState = .confirmMFACode
            case .confirmSignInWithNewPassword:
                print("➡️ Need to set new password")
                errorMessage = "Please set a new password"
                sessionManager.authState = .resetPassword
            case .done:
                if result.isSignedIn {
                    Task {
                        do {
                            let session = try await Amplify.Auth.fetchAuthSession()
                            print("✅ Is user signed in - \(session.isSignedIn)")
                            
                            if session.isSignedIn {
                                print("✅ Session is valid, handling authentication")
                                await handleSuccessfulAuthentication()
                            } else {
                                print("❌ Session is not valid")
                                self.errorMessage = "Session is not valid"
                                self.isAuthenticated = false
                            }
                        } catch {
                            print("❌ Failed to verify session: \(error)")
                            self.errorMessage = "Failed to verify session: \(error.localizedDescription)"
                            self.isAuthenticated = false
                        }
                    }
                } else {
                    print("❌ Sign in completed but user is not signed in")
                    self.errorMessage = "Sign in completed but user is not signed in"
                    self.isAuthenticated = false
                }
            default:
                print("❌ Unexpected authentication step")
                self.errorMessage = "Unexpected authentication step"
                self.isAuthenticated = false
            }
            
        } catch let authError as AuthError {
            print("❌ Sign in failed \(authError)")
            self.errorMessage = authError.errorDescription
            self.isAuthenticated = false
        } catch {
            print("❌ Unexpected error: \(error)")
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }
    }
    
    func confirmPasswordReset(newPassword: String) async {
        guard let result = signInResult else {
            self.errorMessage = "No sign in attempt found"
            return
        }
        
        do {
            let confirmResult = try await Amplify.Auth.confirmSignIn(
                challengeResponse: newPassword
            )
            
            print("✅ Password reset result: \(confirmResult.isSignedIn)")
            
            if confirmResult.isSignedIn {
                self.isAuthenticated = true
                self.errorMessage = nil
                
                // Get the current session after password reset
                let session = try await Amplify.Auth.fetchAuthSession()
                if session.isSignedIn {
                    let cognitoUser = try await Amplify.Auth.getCurrentUser()
                    print("✅ Current user ID: \(cognitoUser.userId)")
                    self.sessionManager.authState = .sessionUser(user: cognitoUser)
                } else {
                    self.errorMessage = "Session is not valid after password reset"
                    self.isAuthenticated = false
                    self.sessionManager.authState = .login
                }
            } else {
                self.errorMessage = "Failed to set new password"
                self.isAuthenticated = false
            }
        } catch let authError as AuthError {
            print("❌ Password reset failed \(authError)")
            self.errorMessage = authError.errorDescription
        } catch {
            print("❌ Unexpected error: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func resetPassword(username: String) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            print("✅ Password reset initiated: \(resetResult)")
            
            switch resetResult.nextStep {
            case .confirmResetPasswordWithCode(let deliveryDetails, _):
                print("➡️ Confirmation code sent via \(deliveryDetails)")
                sessionManager.authState = .resetPassword
            default:
                print("❌ Unexpected reset password response")
                self.errorMessage = "Unexpected reset password response"
            }
        } catch let authError as AuthError {
            print("❌ Reset password error: \(authError)")
            self.errorMessage = authError.errorDescription
        } catch {
            print("❌ Unexpected error: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func showForgotPassword() {
        sessionManager.authState = .forgotPassword
    }
    
    func showLogin() {
        sessionManager.authState = .login
    }
}
