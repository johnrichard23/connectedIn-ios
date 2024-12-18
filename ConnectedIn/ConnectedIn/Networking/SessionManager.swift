//
//  SessionManager.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import Foundation
import Amplify
import AWSPluginsCore
import AuthenticationServices
import AWSCognitoAuthPlugin
import Combine
import AmplifyPlugins

enum UserType {
    case church
    case user
}

enum AuthState {
    case onboarding
    case signUp
    case login
    case forgotPassword
    case userDashboard(user: AuthUser)
    case sessionUser(user: AuthUser)
    case sessionChurch(user: AuthUser)
    case confirmCode(username: String)
    case confirmMFACode
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .onboarding
    static let shared = SessionManager()
    var connectedInUser = User(email: "jahnrichards23@gmail.com")
    var currentEmail: String = ""
    var signInEmail: String = ""
    var signInPassword: String = ""
    var savedTokens: Tokens?
    
    
    func getCurrentAuthUser() async {
        //            authState = .userDashboard(user: DummyUser())
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            
//            self.getAuthToken()
            
            guard let savedUser = UserDefaultsManager.shared.getConnectedInUser() else {
                self.authState = .login
                return
            }
            
            self.currentEmail = savedUser.email
            self.connectedInUser = savedUser
            self.connectedInUser.userID = savedUser.userID
            
            // TO DO: Fix forced unwrapped
            guard let currentUserType: UserType = getCurrentUserRole(userRole: savedUser.role!) else {
                self.authState = .login
                return
            }
            
            switch currentUserType {
            case .church:
                authState = .sessionChurch(user: user)
            case .user:
                authState = .sessionUser(user: user)
            }
        } catch {
//            authState = .userDashboard(user: DummyUser())
            print("Error fetching current user")
        }
    }
        
    
    
    func getCurrentUserRole(userRole: UserRole) -> UserType? {
        switch userRole.role {
        case "church":
            return  .church
        case "user":
            return .user
        default:
            return .user
        }
    }
    
//    func getAuthToken() {
//        Amplify.Auth.fetchAuthSession { result in
//            do {
//                let session = try result.get()
//
//                // Get cognito user pool token
//                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
//                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
//                    // Do something with the Cognito tokens
//                    print("tokens: ")
//                    print(tokens)
//                    let myTokens = Tokens(idToken: tokens.idToken,
//                                            accessToken: tokens.accessToken,
//                                            refreshToken: tokens.refreshToken)
//                    UserDefaultsManager.shared.saveTokens(tokens: myTokens)
//                    self.savedTokens = myTokens
////                    UserDefaultsManager.shared.saveUser(user: LocalUser(email: self.currentEmail ?? "", type: "", token: tokens.accessToken))
//                }
//
//            } catch {
//                print("Fetch auth session failed with error - \(error)")
//            }
//        }
//            
//    }
        
        

//    func fetchAuthSession() async {
//        
//        do {
//            let session = try await Amplify.Auth.fetchAuthSession()
//
//            // Get user sub or identity id
//            if let identityProvider = session as? AuthCognitoIdentityProvider {
//                let usersub = try identityProvider.getUserSub().get()
//                let identityId = try identityProvider.getIdentityId().get()
//                print("User sub - \(usersub) and identity id \(identityId)")
//            }
//
//            // Get AWS credentials
//            if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
//                let credentials = try awsCredentialsProvider.getAWSCredentials().get()
//                // Do something with the credentials
//            }
//
//            // Get cognito user pool token
//            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
//                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
//                // Do something with the JWT tokens
//            }
//        } catch let error as AuthError {
//            print("Fetch auth session failed with error - \(error)")
//        } catch {
//        }
//        
//    }
    
    /// Amplify configuration
    
//    func addAmplifyPlugins() {
//        do {
//            try Amplify.add(plugin: AWSCognitoAuthPlugin() )
////            try Amplify.add(plugin: AWSS3StoragePlugin())
////            try Amplify.add(plugin: AWSAPIPlugin())
//        }
//        catch {
//            print("could not add Amplify plugins.", error)
//        }
//
//    }
        
    
    
    func configureAmplify() {
//        let contentPath = Bundle.main.path(forResource: fileName, ofType: "json")
//        let myUrl = URL(fileURLWithPath: contentPath)
    }
    
//    func login(email: String, password: String,
//               handler: @escaping(_ result: Result<Bool,AuthError>)->()) {
//        
//        self.signInEmail = email
//        self.signInPassword = password
//        
//        _ = Amplify.Auth.signIn(
//            username: email,
//            password: password
//        )   { [weak self] result in
//            
//            self?.currentEmail = email
//            
//            switch result {
//            case .success(let signInResult):
//                print(signInResult)
//                
//                if signInResult.isSignedIn {
//                    DispatchQueue.main.async {
//                        self?.getCurrentAuthUser()
//                    }
//                } else {
//                    
//                    switch signInResult.nextStep {
//                    case .confirmSignUp(let details):
//                        print(details ?? "no details")
//                        DispatchQueue.main.async {
//                            self?.authState = .confirmCode(username: email)
//                        }
//                    case .confirmSignInWithSMSMFACode(_, _):
//                        DispatchQueue.main.async {
//                            self?.authState = .confirmMFACode
//                        }
//                        break
//                        
//                    case .confirmSignInWithCustomChallenge(_): break
//                        
//                    case .confirmSignInWithNewPassword(_): break
//                        
//                    case .resetPassword(_): break
//                        
//                    case .done:
//                        DispatchQueue.main.async {
//                            self?.getCurrentAuthUser()
//                        }
//                        break
//                    }
//                }
//            case .failure(let error):
//                print("Login error:", error)
//                handler(.failure(error) )
//            } // switch
//        }
//    }
    
    
    func showLogin() {
        
    }
    
    func saveConnectedInUser(user: User) {
        self.connectedInUser = user
        print("SM: \(getCurrentUserRole(userRole: user.role!))")
        UserDefaultsManager.shared.saveConnectedInUser(user: self.connectedInUser)
        
    }
    
    func showSignUp() {
        
    }
    
    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.
            
            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}

struct DummyUser: AuthUser {
    let userId: String = "33"
    let username: String = "qamail.jag@gmail.com"
}
