//
//  LandingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    @State private var showingAlert = false
    @State var alertMessage: String = ""
    @State var landingScreenBG: String = "landingScreenBG"
    @State var connectedInLogo: String = "connectedInLogo2"
    @State var getStartedButton: String = "getStartedButton"
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            Image(landingScreenBG)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer()
                Image(connectedInLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 550)
                    .padding(.horizontal, 40)
                    .opacity(0.7)
                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
            }
            
            VStack {
                Text("Connect. Collaborate. Contribute.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.bottom, 230)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .tracking(1.6)
                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                    .padding(.vertical, 100)
            }
            
            VStack(alignment: .leading) {
                Spacer()
                Button(action: {
                    self.isPresented = true
                    //UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .padding(.horizontal, 115)
                        .padding(.vertical, 20)
                        .background(Color.connectedInMain)
                        .cornerRadius(5)
                        .font(.system(size: 16, weight: .regular))
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .tracking(1.0)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1.5)
                }
            }.padding(.vertical, 75)
                .fullScreenCover(isPresented: $isPresented) {
                    OnboardingView(tabStore: tabStore, dashboardStore: dashboardStore)
            }
        }
    }
}

