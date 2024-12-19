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
            logoutButton
        }
        .padding()
    }
    
    private var profileSection: some View {
        HStack(spacing: 10) {
            Image("profileIcon")
                .resizable()
                .frame(width: profileImageSize, height: profileImageSize)
                .clipShape(Circle())
            
            Text("Welcome back!")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            Task {
                await sessionManager.signOut()
            }
        }) {
            Text("Logout")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
        }
    }
    
    // MARK: - Computed Properties
    private var userName: String {
        let firstName = dashboardStore.currentUser.firstName ?? "Richard"
        let lastName = dashboardStore.currentUser.lastName ?? "John"
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
