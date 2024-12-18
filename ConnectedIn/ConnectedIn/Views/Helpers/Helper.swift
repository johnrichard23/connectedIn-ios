//
//  Helper.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/5/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 15))
            .foregroundColor(.red)
            .padding()
            .multilineTextAlignment(.center)
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 17))
            .foregroundColor(.secondary)
            .padding()
            .multilineTextAlignment(.center)
    }
}
