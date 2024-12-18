//
//  FeaturedChurchCardView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import SwiftUI

struct FeaturedChurchCardView: View {
    let church: Church
    @State private var isShowingDetail = false
    @Namespace private var animation
    
    var body: some View {
            NavigationLink {
                ChurchDetailView(church: church)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    // Church Image
                    if let url = URL(string: church.avatarUrl), url.scheme != nil {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .clipped()
                    } else {
                        church.avatarImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .clipped()
                    }
                    
                    // Church Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(church.name)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text(church.address)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        // Learn More Button
                        HStack {
                            Text("Learn More")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.caption)
                        }
                        .foregroundColor(Color.connectedInMain)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(
                            Capsule()
                                .stroke(Color.connectedInMain)
                        )
                    }
                }
            }
            .buttonStyle(.plain)
            .frame(width: 200)
            .padding(10)
        }
    }

//#Preview {
//    NavigationStack {
//        FeaturedChurchCardView(church: Church(
//            id: "1",
//            name: "FFBC Sorsogon",
//            description: "A vibrant church community",
//            avatarUrl: "image1",
//            shortDescription: "Historic cathedral",
//            latitude: 14.5995,
//            longitude: 120.9842,
//            phone: "+63 912 345 6789",
//            email: "ffbc.sorsogon@example.com",
//            address: "Rizal St. Piot, Sorsogon City",
//            facebookUrl: "https://facebook.com/ffbcsorsogon",
//            instagramUrl: "https://instagram.com/ffbcsorsogon",
//            serviceTimes: ["Sunday 8:00 AM", "Sunday 10:30 AM"],
//            region: "San Francisco",
//            photos: ["church1", "church2"],
//            donations: Donations(
//                gcashNumber: "1234567890",
//                bankAccount: BankAccount(
//                    accountNumber: "987654321",
//                    bankName: "Sample Bank"
//                )
//            )
//        ))
//    }
//}
