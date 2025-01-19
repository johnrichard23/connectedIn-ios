//
//  RoundUpRowView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct RoundUpRowView: View {
    let roundUp: RoundUp
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Original Amount: ₱\(String(format: "%.2f", roundUp.originalAmount))")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("Rounded Up: ₱\(String(format: "%.2f", roundUp.amount))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatDate(roundUp.date))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    RoundUpRowView(roundUp: RoundUp(id: "1", amount: 0.75, originalAmount: 9.25, date: Date()))
}
