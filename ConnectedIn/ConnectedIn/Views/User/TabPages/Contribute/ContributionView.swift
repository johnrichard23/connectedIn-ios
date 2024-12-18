//
//  ContributionView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/1/24.
//

import SwiftUI

struct ContributionView: View {
    
    let churches: [Church]
    let missionaries: [Missionary]
    let ministries: [Ministry]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.dashboardHeaderColor,
                            Color.dashboardHeaderColor.opacity(0.85),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea(edges: [.top, .horizontal]) // Don't ignore bottom safe area for tab bar
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Direct Giving Card
                        NavigationLink(destination: DirectGivingView(
                            churches: churches,
                            missionaries: missionaries,
                            ministries: ministries
                        )) {
                            ContributeCardView(
                                title: "Direct Giving",
                                description: "Support churches, missionaries, and ministries through digital donations",
                                icon: "heart.circle.fill",
                                color: .connectedInMain
                            )
                        }
                        
                        // Round Up Card
                        NavigationLink(destination: RoundUpGivingView()) {
                            ContributeCardView(
                                title: "Round Up Giving",
                                description: "Automatically round up your purchases and donate the difference",
                                icon: "arrow.up.circle.fill",
                                color: .green
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Contribute")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.dashboardHeaderColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

//#Preview {
//    ContributionView()
//}
