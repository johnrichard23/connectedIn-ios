//
//  LoginView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/15/24.
//

import SwiftUI

struct LoginView: View {
   
    @EnvironmentObject var sessionManager: SessionManager
    
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Logo
                Image("connectedInBlackLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                
                // Form Fields
                VStack(spacing: 20) {
                    FloatingTextField(title: "Email Address", isSecure: false, text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    FloatingTextField(title: "Password", isSecure: true, text: $password)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal, 20)
                
                // Login Button
                Button {
                    withAnimation {
                        isLoading = true
                    }
                    Task {
                        do {
                            await viewModel.login(username: email, password: password)
                        } catch {
                            // Handle any errors if needed
                        }
                        withAnimation {
                            isLoading = false
                        }
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color.connectedInMain)
                            .cornerRadius(8)
                            .frame(height: 50)
                            .opacity(isLoading ? 0.7 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isLoading)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .transition(.opacity)
                        } else {
                            Text("Login")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .transition(.opacity)
                        }
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                .padding(.horizontal, 20)
                
                // Facebook Login Button
                Button {
                    // Handle Facebook login
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 66/255, green: 103/255, blue: 178/255))
                            .cornerRadius(8)
                            .frame(height: 50)
                        
                        Text("Continue with Facebook")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                // Forgot Password Link
                Button {
                    viewModel.showForgotPassword()
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 14))
                        .foregroundColor(Color.red.opacity(0.8))
                        .underline()
                }
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .background(Color.white)
        .scrollDismissesKeyboard(.immediately)
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
    }
}

struct ErrorAlert: Identifiable {
    let id = UUID()
    let message: String
}
