import Foundation
import Amplify
import AWSCognitoAuthPlugin

protocol AuthCognitoTokensProvider {
    func getIdToken() async throws -> String
}

class AmplifyAuthTokenProvider: AuthCognitoTokensProvider {
    func getIdToken() async throws -> String {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            
            // Get cognito user pool token
            guard let cognitoSession = (session as? AWSAuthCognitoSession),
                  let idToken = try? cognitoSession.getCognitoTokens().get().idToken else {
                throw APIError.authenticationError("Failed to get Cognito tokens")
            }
            
            return idToken
        } catch {
            throw APIError.authenticationError("Failed to get auth token: \(error.localizedDescription)")
        }
    }
}
