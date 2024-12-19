import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

class AppInitializer: ObservableObject {
    @Published var isInitializing: Bool = true
    let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        initializeAWS()
        
        // Ensure we transition out of splash screen even if initialization fails
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            if self.isInitializing {
                self.isInitializing = false
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    self.sessionManager.authState = .sessionUser(user: DummyUser())
                } else {
                    self.sessionManager.authState = .onboarding
                }
            }
        }
    }
    
    private func initializeAWS() {
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
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            print("✅ Auth plugin added successfully")
            
            try Amplify.configure()
            print("✅ Amplify configured successfully")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    self.sessionManager.authState = .sessionUser(user: DummyUser())
                } else {
                    self.sessionManager.authState = .onboarding
                }
                
                // Add a small delay for smooth transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isInitializing = false
                }
            }
        } catch {
            print("❌ Could not initialize Amplify: \(error)")
            if let authError = error as? AuthError {
                print("Auth Error Details: \(authError.errorDescription)")
                print("Recovery Suggestion: \(authError.recoverySuggestion ?? "No recovery suggestion available")")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    self.sessionManager.authState = .sessionUser(user: DummyUser())
                } else {
                    self.sessionManager.authState = .onboarding
                }
                
                // Add a small delay for smooth transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isInitializing = false
                }
            }
        }
    }
}
