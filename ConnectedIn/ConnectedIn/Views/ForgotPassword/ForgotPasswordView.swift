import SwiftUI
import Amplify

struct ForgotPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var isLoading = false
    
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
                    
                    Text("Forgot Password")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    Text("If you're a new user, please try logging in with your temporary password first.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // Form Section
                    VStack(spacing: 20) {
                        FloatingTextField(title: "Email Address", isSecure: false, text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                    }
                    .padding(.horizontal, 20)
                    
                    // Button Section
                    VStack(spacing: 15) {
                        Button {
                            Task {
                                isLoading = true
                                await viewModel.resetPassword(username: email)
                                isLoading = false
                            }
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Reset Password")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.connectedInMain)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(email.isEmpty || isLoading)
                        
                        Button {
                            sessionManager.showLogin()
                        } label: {
                            Text("Back to Login")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
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
