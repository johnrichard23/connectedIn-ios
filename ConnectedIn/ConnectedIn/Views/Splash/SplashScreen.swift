import SwiftUI
import Amplify

struct SplashScreen: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isAnimating = false
    @Binding var isInitializing: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Image("connectedInlight-logo")
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.6)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            // Check auth state after animation starts
            Task {
                await checkAuthState()
            }
        }
    }
    
    private func checkAuthState() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("✅ Auth session: \(session)")
            
            if session.isSignedIn {
                print("✅ User is signed in")
                await sessionManager.getCurrentAuthUser()
            } else {
                print("❌ User is NOT signed in")
            }
            
            // Add a small delay for splash screen animation
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds
            
            DispatchQueue.main.async {
                withAnimation {
                    isInitializing = false
                }
            }
        } catch {
            print("❌ Failed to get auth session:", error)
            DispatchQueue.main.async {
                isInitializing = false
            }
        }
    }
}
