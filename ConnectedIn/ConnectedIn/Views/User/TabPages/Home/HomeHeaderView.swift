//
//  HomeHeaderView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/6/24.
//

import SwiftUI

struct HomeHeaderView: View {
    // MARK: - Dependencies
    @EnvironmentObject private var sessionManager: SessionManager
    @ObservedObject private var tabStore: UserTabStore
    @ObservedObject private var dashboardStore: UserDashboardViewModel
    
    // MARK: - State
    @State private var selectedIndex = 0
    @State private var searchText = ""
    @State private var isPresentingChurchesListScreen = false
    @State private var isDetailsViewHidden = false
    
    // MARK: - Constants
    private let profileImageSize: CGFloat = 36
    private let menuButtonSize: CGFloat = 32
    
    // MARK: - Initialization
    init(tabStore: UserTabStore, dashboardStore: UserDashboardViewModel) {
        self.tabStore = tabStore
        self.dashboardStore = dashboardStore
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.connectedInHomeBG
            
            VStack(alignment: .leading, spacing: 5) {
                headerContent
            }
        }
        .foregroundColor(.black)
        .padding(5)
    }
    
    // MARK: - Private Views
    private var headerContent: some View {
        HStack {
            profileSection
            Spacer()
            menuButton
        }
        .padding()
    }
    
    private var profileSection: some View {
        HStack {
            profileImage
            userGreeting
        }
    }
    
    private var profileImage: some View {
        Image("profileIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: profileImageSize, maxHeight: profileImageSize)
            .accessibilityLabel("Profile picture")
    }
    
    private var userGreeting: some View {
        Text("Hi \(userName)")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.black)
            .accessibilityLabel("Greeting for \(userName)")
    }
    
    private var menuButton: some View {
        Image("menuButton")
            .resizable()
            .foregroundColor(.white)
            .aspectRatio(contentMode: .fill)
            .frame(width: menuButtonSize, height: menuButtonSize)
            .padding(.trailing, 1)
            .accessibilityLabel("Menu")
    }
    
    // MARK: - Computed Properties
    private var userName: String {
        let firstName = dashboardStore.currentUser.firstName ?? "Richard"
        let lastName = dashboardStore.currentUser.lastName ?? "John"
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
