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
                    
                    // Form Section
                    VStack(spacing: 20) {
                        FloatingTextField(title: "Email Address", isSecure: false, text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        
                        FloatingTextField(title: "Password", isSecure: true, text: $password)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal, 20)
                    
                    // Button Section
                    VStack(spacing: 15) {
                        Button {
                            isLoading = true
                            Task {
                                await viewModel.login(username: email, password: password)
                                isLoading = false
                            }
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Log In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.connectedInMain)
                        .cornerRadius(8)
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                        
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button {
                                viewModel.showForgotPassword()
                            } label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 10)
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
        .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                print("✅ User is authenticated, navigating to dashboard")
            }
        }
        .preferredColorScheme(.light)
    }
}

struct ErrorAlert: Identifiable {
    let id = UUID()
    let message: String
}
