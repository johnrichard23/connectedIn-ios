//
//  ChurchesGroupView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/4/24.
//

import SwiftUI

struct ChurchesGroupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ChurchViewModel()
    @State private var isLoading = true
    @State private var selectedRegion: String? = nil
    
    private func churchesForGroup(_ group: String) -> [Church] {
        viewModel.churches.filter { $0.countryGroup == group }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Quick Stats Section - Moved to top for better hierarchy
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total Churches",
                            value: "\(viewModel.churches.count)",
                            icon: "building.2.fill"
                        )
                        
                        StatCard(
                            title: "Regions",
                            value: "\(Constants.countryGroups.count)",
                            icon: "map.fill"
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Discover")
                        .font(.system(size: 34, weight: .bold)) // System font for better legibility
                        .foregroundColor(.black)
                    
                    Text("Find churches near you")
                        .font(.system(size: 17)) // Standard iOS size
                        .foregroundColor(.darkGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Region Cards
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)],
                         spacing: 20) {
                    ForEach(Constants.countryGroups, id: \.self) { group in
                        NavigationLink(
                            destination: ChurchesListView(
                                churches: churchesForGroup(group),
                                region: group
                            )
                        ) {
                            ModernRegionCardView(
                                region: group,
                                churchCount: churchesForGroup(group).count,
                                isSelected: selectedRegion == group
                            )
                        }
                        .buttonStyle(RegionCardButtonStyle()) // Custom button style for better touch feedback
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.connectedInHomeBG) // Standard iOS background color
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("AFBCP Churches")
                    .font(.system(size: 17, weight: .semibold)) // Standard nav title size
                    .foregroundColor(.black)
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                isLoading = false
            }
            viewModel.fetchChurches()
        }
    }
}

// Custom button style for region cards
struct RegionCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minHeight: 44) // Minimum touch target
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Updated StatCard for better accessibility and touch targets
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.connectedInMain) // Standard iOS blue
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Text(title)
                .font(.system(size: 15)) // Standard iOS size
                .foregroundColor(.black)
        }
        .padding(16)
        .frame(minHeight: 44) // Minimum touch target
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// Updated ModernRegionCardView for better accessibility
struct ModernRegionCardView: View {
    let region: String
    let churchCount: Int
    let isSelected: Bool
    
    private var coverImage: String {
        switch region {
        case "Luzon": return "luzon-cover"
        case "Visayas": return "visayas-cover"
        case "Mindanao": return "mindanao-cover"
        default: return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                // Background Image
                Image(coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                // Gradient Overlay for better text contrast
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.4),
                        .black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Content Overlay
                VStack(alignment: .leading, spacing: 12) {
                    Text(region)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(region)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "building.2.fill")
                                .foregroundColor(Color.connectedInMain)
                            Text("\(churchCount) Churches")
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
