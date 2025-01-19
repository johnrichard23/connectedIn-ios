//
//  MinistryRowView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct MinistryRowView: View {
    let ministry: Ministry
    
    var body: some View {
        HStack(spacing: 16) {
            // Ministry Avatar
            AsyncImage(url: URL(string: ministry.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            // Ministry Information
            VStack(alignment: .leading, spacing: 4) {
                Text(ministry.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(ministry.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Location and Contact
                HStack(spacing: 12) {
                    Label(ministry.location, systemImage: "mappin.circle.fill")
                        .foregroundStyle(.secondary)
                    
                    Label(ministry.phone, systemImage: "phone.fill")
                        .foregroundStyle(.secondary)
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
//    MinistryRowView()
//}
