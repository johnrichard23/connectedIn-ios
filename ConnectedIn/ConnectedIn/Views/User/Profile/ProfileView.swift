//
//  ProfileView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 1/19/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var firstName: String = "John"
    @State private var lastName: String = "Doe"
    @State private var email: String = "john.doe@email.com"
    @State private var homeChurch: String = "Grace Community Church"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 6) {
                    Image("profileIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.connectedInMain)
                        .padding(.top)
                    
                    Text("\(firstName) \(lastName)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(homeChurch)
                        .font(.subheadline)
                        .foregroundColor(Color.connectedInMain)
                        .padding(.top, 8)
                }
                .padding(.bottom, 20)

                // Quick Stats
                HStack {
                    StatView(title: "Donations", value: "12", icon: "gift.circle.fill")
                    Divider()
                        .frame(height: 40)
                    StatView(title: "Churches", value: "5", icon: "building.2.fill")
                    Divider()
                        .frame(height: 40)
                    StatView(title: "Events", value: "8", icon: "calendar.circle.fill")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 0.5)
                .padding(.horizontal)
                
                // Menu Items
                VStack(spacing: 0) {
                    MenuItemView(icon: "person.fill", title: "Edit Profile")
                    MenuItemView(icon: "building.2.fill", title: "My Church")
                    MenuItemView(icon: "heart.fill", title: "Saved Churches")
                    MenuItemView(icon: "gift.fill", title: "Donation History")
                    MenuItemView(icon: "gear", title: "Settings")
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 0.5)
                .padding()
                
                Button(action: {
                    // Handle sign out
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .background(Color.connectedInHomeBG)
    }
}

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color.connectedInMain)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {
            // Handle menu item tap
        }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 30)
                    .foregroundColor(Color.connectedInMain)
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        Divider()
    }
}
