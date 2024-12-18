//
//  ChurchDetailView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/31/24.
//

import SwiftUI
import MapKit

struct ChurchDetailView: View {
    let church: Church
    @State private var position: MapCameraPosition
    @State private var isMapLoaded = false
    @Environment(\.dismiss) private var dismiss
    
    
    init(church: Church) {  // Simplified init
        self.church = church
        let coordinate = CLLocationCoordinate2D(
            latitude: church.latitude,
            longitude: church.longitude
        )
        _position = State(initialValue: .camera(MapCamera(
            centerCoordinate: coordinate,
            distance: 2000,
            heading: 0,
            pitch: 0
        )))
    }
    
    var body: some View {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .bottom) {
                            // Header Image
                            if let url = URL(string: church.avatarUrl), url.scheme != nil {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: geometry.size.width, height: 300)
                                .clipShape(
                                    CustomCornerShape(radius: 30, corners: [.bottomLeft, .bottomRight])
                                )
                            } else {
                                church.avatarImage
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 400)
                                    .clipShape(
                                        CustomCornerShape(radius: 30, corners: [.bottomLeft, .bottomRight])
                                    )
                            }
                            
                            // Add a gradient overlay for better text visibility
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .clear,
                                    .black.opacity(0.5)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 100)
                            .clipShape(
                                CustomCornerShape(radius: 30, corners: [.bottomLeft, .bottomRight])
                            )
                        }
                        .frame(width: geometry.size.width, height: 300)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            // Church Name and Location
                            VStack(alignment: .leading, spacing: 8) {
                                Text(church.name)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(church.address)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 80)
                            
                            // Map
                            Map(position: $position) {
                                Marker(church.name, coordinate: CLLocationCoordinate2D(
                                    latitude: church.latitude,
                                    longitude: church.longitude
                                ))
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            // Description
                            if !church.description.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text(church.description)
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .lineSpacing(4)
                                }
                            }
                            
                            // Contact Information
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contact Information")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                
                                if !church.phone.isEmpty {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                        Text(church.phone)
                                    }
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                }
                                
                                if !church.email.isEmpty {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                        Text(church.email)
                                    }
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                }
                            }
                            
                            // Service Times
                            if !church.serviceTimes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Service Times")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    ForEach(church.serviceTimes, id: \.self) { time in
                                        Text(time)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            // Photos Section
                            if !church.photos.isEmpty {
                                ChurchPhotosView(photos: church.photos)
                            }
                            
                            // Social Media Links
                            if !church.facebookUrl.isEmpty || !church.instagramUrl.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Social Media")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    HStack(spacing: 20) {
                                        if !church.facebookUrl.isEmpty {
                                            Link(destination: URL(string: church.facebookUrl)!) {
                                                HStack {
                                                    Image(systemName: "link")
                                                    Text("Facebook")
                                                }
                                                .font(.system(size: 16))
                                                .foregroundColor(.blue)
                                            }
                                        }
                                        
                                        if !church.instagramUrl.isEmpty {
                                            Link(destination: URL(string: church.instagramUrl)!) {
                                                HStack {
                                                    Image(systemName: "link")
                                                    Text("Instagram")
                                                }
                                                .font(.system(size: 16))
                                                .foregroundColor(.purple)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Donations Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Donations")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    // GCash
                                    if !church.donations.gcashNumber.isEmpty {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("GCash")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Text(church.donations.gcashNumber)
                                                .font(.system(size: 16))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    // Bank Account
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Bank Account")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        Text(church.donations.bankAccount.bankName)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                        
                                        Text(church.donations.bankAccount.accountNumber)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
            .background(Color.connectedInHomeBG)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

private struct ChurchPhotosView: View {
    let photos: [String]
    @State private var loadedPhotos = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photos")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
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
//#Preview {
//    ChurchDetailView(church: Church(id: "", name: "FFBC Sorsogon", description: "A church that is vibrant", avatarUrl: "image1", shortDescription: "a short church description", latitude: 14.5995, longitude: 120.9842, address: "Rizal St. Piot, Sorsogon City", region: "Bicol", photos: [], donations: Donations(gcashNumber: "+63908123452", bankAccount: BankAccount(accountNumber: "1010293844", bankName: "Bank of the Philippine Islands"))))
//}
