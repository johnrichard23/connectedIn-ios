//
//  ChurchCardView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 6/13/24.
//

import SwiftUI

struct ChurchCardView: View {
    var title: String
    var description: String
    var churchesCount: String
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 190)
                    .clipped()
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack() {
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                            .frame(alignment: .leading)
                    }
                    
                    HStack(alignment: .top) {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .trailing) {
                        Text(churchesCount)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
//                    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .bottomTrailing)
                    
                }
                .padding([ .horizontal, .vertical], 20)
            }
//            .foregroundColor(Color.white)
//            .cornerRadius(10)
//            .shadow(color: .gray, radius: 5)
//            .padding([ .horizontal], 5)
//            .frame(height: 190)
        }
    }
}

