//
//  ChurchDetailView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/31/24.
//

import SwiftUI
import MapKit

struct ChurchDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    let church: Church
    let useCloseButton: Bool
    @State private var position: MapCameraPosition
    
    init(church: Church, useCloseButton: Bool = false) {
        self.church = church
        self.useCloseButton = useCloseButton
        self._position = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: church.latitude,
                longitude: church.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ChurchHeroHeader(church: church)
                ChurchContentSection(church: church)
            }
        }
        .background(Color.connectedInHomeBG)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: useCloseButton ? .navigationBarTrailing : .navigationBarLeading) {
                Button(action: {
                    if useCloseButton {
                        dismiss()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    if useCloseButton {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding(8)
                    } else {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - Hero Header
private struct ChurchHeroHeader: View {
    let church: Church
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Header Image
            GeometryReader { geo in
                if let url = URL(string: church.avatarUrl), url.scheme != nil {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 280)
                            .clipped()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                            .frame(width: geo.size.width, height: 280)
                    }
                } else {
                    Image(church.avatarUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: 280)
                        .clipped()
                }
            }
            .frame(height: 280)
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .black.opacity(0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            
            // Church Name and Location
            VStack(spacing: 8) {
                Spacer()
                Text(church.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color.connectedInMain)
                    Text(church.address)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(height: 280)
        }
    }
}

// MARK: - Content Section
private struct ChurchContentSection: View {
    let church: Church
    
    var body: some View {
        VStack(spacing: 24) {
            // About Section
            if !church.description.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "About", icon: "info.circle.fill")
                    
                    Text(church.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                        .padding(.horizontal, 4)
                }
            }
            
            // Contact Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Contact", icon: "person.circle.fill")
                
                VStack(spacing: 16) {
                    if !church.phone.isEmpty {
                        ContactButton(
                            icon: "phone.fill",
                            text: church.phone,
                            action: { /* Handle phone tap */ }
                        )
                    }
                    
                    if !church.email.isEmpty {
                        ContactButton(
                            icon: "envelope.fill",
                            text: church.email,
                            action: { /* Handle email tap */ }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
            
            // Service Times
            if !church.serviceTimes.isEmpty {
                ChurchServiceTimesSection(serviceTimes: church.serviceTimes)
            }
            
            // Location Map
            ChurchLocationSection(church: church)
            
            // Donations
            ChurchDonationsSection(donations: church.donations)
            
            // Photos Grid
            if !church.photos.isEmpty {
                ChurchPhotosSection(photos: church.photos)
            }
            
            // Social Links
            if !church.facebookUrl.isEmpty || !church.instagramUrl.isEmpty {
                ChurchSocialLinksSection(church: church)
            }
        }
        .padding(20)
    }
}

// MARK: - Service Times Section
private struct ChurchServiceTimesSection: View {
    let serviceTimes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Service Times", icon: "clock.fill")
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(serviceTimes, id: \.self) { time in
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.connectedInMain)
                            .frame(width: 22)
                        Text(time)
                            .foregroundColor(.secondary)
                    }
                    .font(.system(size: 16))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Location Section
private struct ChurchLocationSection: View {
    let church: Church
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Location", icon: "map.fill")
            
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    Marker(church.name, coordinate: CLLocationCoordinate2D(
                        latitude: church.latitude,
                        longitude: church.longitude
                    ))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                // Get Directions Button
                Button(action: { /* Handle directions */ }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Get Directions")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.connectedInMain)
                    .clipShape(Capsule())
                }
                .padding(.bottom, 16)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
            }
        }
    }
}

// MARK: - Donations Section
private struct ChurchDonationsSection: View {
    let donations: Donations
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Support Us", icon: "heart.circle.fill")
            
            VStack(spacing: 16) {
                if !donations.gcashNumber.isEmpty {
                    DonationMethod(
                        title: "GCash",
                        icon: "phone.fill",
                        details: donations.gcashNumber
                    )
                }
                
                DonationMethod(
                    title: "Bank Transfer",
                    icon: "building.columns.fill",
                    details: [
                        donations.bankAccount.bankName,
                        donations.bankAccount.accountNumber
                    ]
                )
            }
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Photos Section
private struct ChurchPhotosSection: View {
    let photos: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Photos", icon: "photo.fill")
            ChurchPhotosView(photos: photos)
        }
    }
}

// MARK: - Social Links Section
private struct ChurchSocialLinksSection: View {
    let church: Church
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Connect With Us", icon: "link.circle.fill")
            
            HStack(spacing: 12) {
                if let facebookUrl = URL(string: church.facebookUrl) {
                    SocialLink(
                        title: "Facebook",
                        icon: "facebook",
                        color: Color(red: 0.23, green: 0.35, blue: 0.6),
                        url: facebookUrl
                    )
                }
                
                if let instagramUrl = URL(string: church.instagramUrl) {
                    SocialLink(
                        title: "Instagram",
                        icon: "instagram",
                        color: Color(red: 0.8, green: 0.2, blue: 0.5),
                        url: instagramUrl
                    )
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color.connectedInMain)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

struct ContactButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.connectedInMain)
                    .frame(width: 24)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct SocialLink: View {
    let title: String
    let icon: String
    let color: Color
    let url: URL
    
    var body: some View {
        Link(destination: url) {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color)
            .cornerRadius(12)
        }
    }
}

struct DonationMethod: View {
    let title: String
    let icon: String
    let details: String
    
    init(title: String, icon: String, details: String) {
        self.title = title
        self.icon = icon
        self.details = details
    }
    
    init(title: String, icon: String, details: [String]) {
        self.title = title
        self.icon = icon
        self.details = details.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.connectedInMain)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Text(details)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.leading, 32)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
}

private struct ChurchPhotosView: View {
    let photos: [String]
    @State private var loadedPhotos = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if loadedPhotos {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(photos, id: \.self) { photo in
                            if let url = URL(string: photo), url.scheme != nil {
                                // Remote image
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 200, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                // Local image
                                Image(photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Delay loading photos slightly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                loadedPhotos = true
            }
        }
    }
}
