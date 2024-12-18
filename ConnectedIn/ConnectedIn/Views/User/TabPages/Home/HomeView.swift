//
//  UserHomeView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 5/3/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardViewModel
    
    @Binding var isButtonTapped: Bool
    
    var body: some View {

        if isButtonTapped {
            
        }
        else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HomeHeaderView(tabStore: tabStore, dashboardStore: dashboardStore).environmentObject(sessionManager)
                }

                VStack(alignment: .leading) {
                    FeaturedCardView()
                }
            }
            .background(Color.connectedInHomeBG)
            .onAppear{
            }
        }
    }
}

