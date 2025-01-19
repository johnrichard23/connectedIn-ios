//
//  ChurchRowView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct ChurchRowView: View {
    let church: Church
    
    var body: some View {
        HStack(spacing: 16) {
            // Church Avatar
            AsyncImage(url: URL(string: church.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "building.2.fill")
                    .foregroundStyle(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            // Church Information
            VStack(alignment: .leading, spacing: 4) {
                Text(church.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(church.shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Location and Service Times
                HStack(spacing: 12) {
                    Label(church.region, systemImage: "mappin.circle.fill")
                        .foregroundStyle(.secondary)
                    
                    if let nextService = church.serviceTimes.first {
                        Label(nextService, systemImage: "clock.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.caption)
            }
            
            Spacer()
            
            // Navigation Indicator
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.caption.bold())
        }
        .padding(.vertical, 8)
    }
}

//#Preview {
//    ChurchRowView()
//}
