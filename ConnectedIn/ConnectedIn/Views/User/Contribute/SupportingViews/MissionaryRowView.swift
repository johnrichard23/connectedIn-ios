//
//  MissionaryRowView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct MissionaryRowView: View {
    let missionary: Missionary
    
    var body: some View {
        HStack(spacing: 16) {
            // Missionary Avatar
            AsyncImage(url: URL(string: missionary.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.fill")
                    .foregroundStyle(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            // Missionary Information
            VStack(alignment: .leading, spacing: 4) {
                Text(missionary.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(missionary.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Location and Contact
                HStack(spacing: 12) {
                    Label(missionary.location, systemImage: "mappin.circle.fill")
                        .foregroundStyle(.secondary)
                    
                    Label(missionary.email, systemImage: "envelope.fill")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .font(.caption)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.caption.bold())
        }
        .padding(.vertical, 8)
    }
}

//#Preview {
//    MissionaryRowView()
//}
