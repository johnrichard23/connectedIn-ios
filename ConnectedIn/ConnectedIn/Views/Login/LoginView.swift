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
    
    @State private var showingAlert = false
    @State var alertMessage: String = ""
    @State var landingScreenBG: String = "landingScreenBG"
    @State var connectedInLightLogo: String = "connectedInBlackLogo"
    @State var getStartedButton: String = "getStartedButton"
    @State private var isPresented: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    let textBoxWidth = 50.0
    let textBoxHeight = 38.0
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .preferredColorScheme(.light)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Image(connectedInLightLogo)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 40)
                    
                    VStack(alignment: .leading) {
                        FloatingTextField(title: "Enter your email", isSecure: false, text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        FloatingTextField(title: "Enter your password", isSecure: true, text: $password)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Button {
                            Task {
                                hasSeenOnboarding = true
                                viewModel.login(username: email, password: password)
                            }
                        } label: {
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.connectedInMain)
                                .cornerRadius(5)
                                .font(.system(size: 16, weight: .semibold))
                                .tracking(1.0)
                                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                        }
                        
                        Button {
                            sessionManager.showSignUp()
                        } label: {
                            Text("Continue with Facebook")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.connectedInFB)
                                .cornerRadius(5)
                                .font(.system(size: 16, weight: .semibold))
                                .fontWeight(.bold)
                                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                        }
                        
                        HStack {
                            Button {
                                sessionManager.showSignUp()
                            } label: {
                                Text("Don't have an account?")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 14, weight: .regular))
                            }
                            
                            Button {
                                sessionManager.showSignUp()
                            } label: {
                                Text("Sign Up")
                                    .foregroundColor(Color.connectedInRed)
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
//                DashboardUserView(tabStore: tabStore, dashboardStore: dashboardStore)
            }
        }
    }
}
