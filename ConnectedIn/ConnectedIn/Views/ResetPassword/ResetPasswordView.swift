import SwiftUI
import Amplify

struct ResetPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Logo Section
                    Image("connectedInBlackLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.6)
                        .padding(.top, geometry.size.height * 0.1)
                        .padding(.bottom, 40)
                    
                    Text("Set New Password")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    // Form Section
                    VStack(spacing: 20) {
                        FloatingTextField(title: "New Password", isSecure: true, text: $newPassword)
                            .textInputAutocapitalization(.never)
                        
                        FloatingTextField(title: "Confirm Password", isSecure: true, text: $confirmPassword)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal, 20)
                    
                    // Button Section
                    Button {
                        guard newPassword == confirmPassword else {
                            viewModel.errorMessage = "Passwords do not match"
                            return
                        }
                        Task {
                            await viewModel.confirmPasswordReset(newPassword: newPassword)
                        }
                    } label: {
                        Text("Set Password")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.connectedInMain)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    Spacer(minLength: 0)
                }
                .frame(minHeight: geometry.size.height)
            }
            .background(Color.white.ignoresSafeArea())
            .scrollDismissesKeyboard(.immediately)
        }
        .alert(item: Binding(
            get: { viewModel.errorMessage.map { ErrorAlert(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .preferredColorScheme(.light)
    }
}
