//
//  FeaturedCardView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import SwiftUI

struct FeaturedCardView: View {
    @StateObject private var churchViewModel = ChurchViewModel()
    @StateObject private var dummyViewModel = FeaturedViewModel()
    @StateObject private var missionaryViewModel = MissionaryViewModel()
    @StateObject private var ministryViewModel = MinistryViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) { // Increased spacing for better visual hierarchy
                // Donation Card Section
                DonationCardView(balance: dummyViewModel.donationBalance)
                
                // Featured Sections
                if churchViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    // Featured Content
                    FeaturedContentView(
                        churches: churchViewModel.churches,
                        missionaries: missionaryViewModel.missionaries,
                        ministries: ministryViewModel.ministries,
                        error: churchViewModel.error
                    )
                }
            }
            .padding(.vertical)
        }
        .background(Color.connectedInHomeBG)
        .onAppear {
            churchViewModel.fetchChurches()
            missionaryViewModel.fetchMissionaries()
            ministryViewModel.fetchMinistries()
        }
    }
}

// MARK: - Supporting Views

private struct DonationCardView: View {
    let balance: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Balance Display
            VStack(spacing: 8) {
                Text("Donated Amount")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                Text(balance)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Action Buttons
            HStack(spacing: 16) {
                ActionButton(title: "Give", action: {})
                ActionButton(title: "History", action: {})
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.dashboardHeaderColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

private struct ActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44) // Apple's minimum touch target
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}

private struct FeaturedContentView: View {
    let churches: [Church]
    let missionaries: [Missionary]
    let ministries: [Ministry]
    let error: Error?
    
    var body: some View {
        VStack(spacing: 24) {
            if let error = error {
                ErrorView(message: error.localizedDescription)
            } else if churches.isEmpty || missionaries.isEmpty || ministries.isEmpty {
                EmptyStateView(message: "No featured content available")
            } else {
                // Featured Sections
                FeaturedSection(
                    title: "Featured Churches",
                    destination: ChurchesGroupView()
                ) {
                    FeaturedChurchesScrollView(churches: churches)
                }
                
                FeaturedSection(
                    title: "Featured Missionaries",
                    destination: ChurchesGroupView()
                ) {
                    FeaturedMissionariesScrollView(missionaries: missionaries)
                }
                
                FeaturedSection(
                    title: "Featured Ministries",
                    destination: ChurchesGroupView()
                ) {
                    FeaturedMinistriesScrollView(ministries: ministries)
                }
            }
        }
    }
}

// MARK: - Featured Scroll Views
private struct FeaturedChurchesScrollView: View {
    let churches: [Church]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(churches) { church in
                    NavigationLink(destination: ChurchDetailView(church: church)) {
                        FeaturedChurchCard(church: church)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct FeaturedMissionariesScrollView: View {
    let missionaries: [Missionary]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(missionaries) { missionary in
                    NavigationLink(destination: Text("Missionary Detail")) {
                        FeaturedMissionaryCard(missionary: missionary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct FeaturedMinistriesScrollView: View {
    let ministries: [Ministry]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(ministries) { ministry in
                    NavigationLink(destination: Text("Ministry Detail")) {
                        FeaturedMinistryCard(ministry: ministry)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Featured Cards
private struct FeaturedChurchCard: View {
    let church: Church
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AdaptiveImageView(
                imageSource: church.avatarUrl,
                placeholder: "building.2"
            )
            .frame(width: 200, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(church.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(church.address)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .frame(width: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

private struct FeaturedMissionaryCard: View {
    let missionary: Missionary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AdaptiveImageView(
                imageSource: missionary.avatarUrl,
                placeholder: "person.fill"
            )
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(missionary.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                
                Text(missionary.location)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(width: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

private struct FeaturedMinistryCard: View {
    let ministry: Ministry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AdaptiveImageView(
                imageSource: ministry.avatarUrl,
                placeholder: "building.2"
            )
            .frame(width: 200, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ministry.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(ministry.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
    
                Button(action: {
                    // Add your action here
                }) {
                    HStack {
                        Text("Learn More")
                            .font(.system(size: 12, weight: .medium))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.connectedInMain)
                            .shadow(
                                color: Color.black.opacity(0.15),
                                radius: 2,
                                x: 0,
                                y: 1
                            )
                    )
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .frame(width: 200)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 2
        )
        // Cache the rendered result
        .drawingGroup()
    }
}

// MARK: - Custom Image Loading View
private struct AdaptiveImageView: View {
    let imageSource: String
    let placeholder: String
    
    var body: some View {
        Group {
            if imageSource.hasPrefix("http") || imageSource.hasPrefix("https"),
               let url = URL(string: imageSource) {
                // Remote image
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    case .failure(_):
                        fallbackImage
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                // Local asset
                Image(imageSource)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .onAppear {
                        // Debug print to verify asset loading
                        #if DEBUG
                        print("Loading local image: \(imageSource)")
                        #endif
                }
            }
        }
        .clipped()
    }
    
    private var fallbackImage: some View {
        Image(systemName: placeholder)
            .font(.system(size: 30))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}

private struct FeaturedSection<Destination: View, Content: View>: View {
    let title: String
    let destination: Destination
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                NavigationLink(destination: destination) {
                    HStack(spacing: 4) {
                        Text("See all")
                            .font(.system(size: 15, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(Color.connectedInMain)
                }
            }
            .padding(.horizontal)
            
            content()
        }
    }
}
//#Preview {
//    FeaturedCardView()
//}
