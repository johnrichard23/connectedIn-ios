//
//  FeaturedMinistryCardView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import SwiftUI

struct FeaturedMinistryCardView: View {
    let ministry: Ministry
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(ministry.avatarUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 130)
                .cornerRadius(10)
                .clipped()
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(ministry.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(ministry.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button(action: {
                    // Action for "Learn More"
                }) {
                    Text("Learn More")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.connectedInMain)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(width: 210, height: 260)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

//#Preview {
//    FeaturedMinistryCardView(ministry: Ministry(id: 3, name: "CrossDrive Missions", description: "Young missionaries in Bicol", imageUrl: "ministry1"))
//}
