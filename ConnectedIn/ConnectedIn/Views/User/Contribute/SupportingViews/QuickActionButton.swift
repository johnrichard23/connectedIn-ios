//
//  QuickActionButton.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/21/24.
//

import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.connectedInMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}
