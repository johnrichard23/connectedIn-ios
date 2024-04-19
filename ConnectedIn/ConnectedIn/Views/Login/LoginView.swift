//
//  LoginView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/15/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showingAlert = false
    @State var alertMessage: String = ""
    @State var landingScreenBG: String = "landingScreenBG"
    @State var connectedInLightLogo: String = "connectedInBlackLogo"
    @State var getStartedButton: String = "getStartedButton"
    @State private var isPresented: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    let textBoxWidth = 50.0
    let textBoxHeight = 38.0
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15){
                Spacer()
                Image(connectedInLightLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 510)
                    .padding(.horizontal, 40)
            }.padding(.bottom, 60)
            VStack(alignment: .leading) {
                FloatingTextField(title: "Enter your email", isSecure: false, text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                FloatingTextField(title: "Enter your password", isSecure: true, text: $password)
                    .autocapitalization(.none)
                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
            }.padding(.horizontal, 20)
                .padding(.bottom, 30)
            VStack(alignment: .leading) {
                Spacer()
                Button {
                    self.isPresented = true
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.horizontal, 153)
                        .padding(.vertical, 20)
                        .background(Color.connectedInMain)
                        .cornerRadius(5)
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(1.0)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                Button {
                    //                    print("Forgot Password?")
                    sessionManager.showSignUp()
                } label: {
                    Text("Continue with Facebook")
                        .foregroundColor(.white)
                        .padding(.horizontal, 83)
                        .padding(.vertical, 20)
                        .background(Color.connectedInFB)
                        .cornerRadius(5)
                        .font(.system(size: 16, weight: .semibold))
                        .fontWeight(.bold)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                Button {
                    //                    print("Forgot Password?")
                    sessionManager.showSignUp()
                } label: {
                    Text("Forgot Password?")
                        .foregroundColor(Color.connectedInRed)
                        .font(.system(size: 14, weight: .regular))
                }.padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }.padding(.vertical, 135)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $isPresented) {
                    DashboardView()
            }
        }
    }
}



#Preview {
    LoginView()
}
