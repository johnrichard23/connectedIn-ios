//
//  ChurchesListView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/4/24.
//

import SwiftUI

struct ChurchesListView: View {
    let churches: [Church]
    let region: String
    
    private var groupedChurches: [String: [Church]] {
        let regions = Constants.regions[region] ?? []
        var grouped: [String: [Church]] = [:]
        
        for subRegion in regions {
            grouped[subRegion] = []
        }
        
        for church in churches {
            grouped[church.region, default: []].append(church)
        }
        
        return grouped.filter { !$0.value.isEmpty }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) { // Increased spacing for better readability
                ForEach(Array(groupedChurches.keys.sorted()), id: \.self) { subRegion in
                    VStack(alignment: .leading, spacing: 16) {
                        // Region Header with proper contrast and size
                        RegionHeaderView(
                            region: subRegion,
                            churchCount: groupedChurches[subRegion]?.count ?? 0
                        )
                        .padding(.horizontal, 20)
                        
                        // Churches in this region
                        if let regionChurches = groupedChurches[subRegion] {
                            ForEach(regionChurches) { church in
                                NavigationLink(
                                    destination: ChurchDetailView(church: church)
                                ) {
                                    ChurchesRowView(church: church)
                                }
                                .buttonStyle(ChurchButtonStyle()) // Custom button style for 44pt minimum
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.connectedInHomeBG)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(region) Churches")
                    .font(.system(size: 17, weight: .semibold)) // Apple's standard nav title size
                    .foregroundColor(.black)
            }
        }
    }
}

// Custom button style to ensure minimum tap target size
struct ChurchButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minHeight: 44) // Minimum touch target height
            .contentShape(Rectangle()) // Ensures the entire area is tappable
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 20)
            .opacity(configuration.isPressed ? 0.9 : 1.0) // Visual feedback
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Subtle animation
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RegionHeaderView: View {
    let region: String
    let churchCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(region)
                .font(.system(size: 22, weight: .bold)) // At least 11pt as per guidelines
                .foregroundColor(.black) // Ensures good contrast
            
            Text("\(churchCount) \(churchCount == 1 ? "Church" : "Churches")")
                .font(.system(size: 15, weight: .regular)) // System font for better legibility
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct ChurchesRowView: View {
    let church: Church
    
    var body: some View {
        HStack(spacing: 16) {
            // Church Image with proper aspect ratio
            ChurchImageView(imageUrl: church.avatarUrl)
            
            VStack(alignment: .leading, spacing: 8) { // Increased spacing for better readability
                Text(church.name)
                    .font(.system(size: 17, weight: .semibold)) // Standard iOS list title size
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(church.address)
                    .font(.system(size: 15)) // Standard iOS list subtitle size
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .lineSpacing(4) // Better text spacing
                
                if let firstService = church.serviceTimes.first {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(Color.connectedInMain)
                        Text(firstService)
                            .font(.system(size: 13))
                            .foregroundColor(Color.connectedInMain)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(16)
    }
}

struct ChurchImageView: View {
    let imageUrl: String
    
    var body: some View {
        Group {
            if let url = URL(string: imageUrl), url.scheme != nil {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill) // Maintains aspect ratio
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
            } else {
                Image(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: 60, height: 60)
        .cornerRadius(12)
        .clipped()
    }
}
