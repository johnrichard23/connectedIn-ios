//
//  AllChurchesScreenView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 6/13/24.
//

import SwiftUI

struct AllChurchesScreenView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var tabStore: UserTabStore
    @ObservedObject var dashboardStore: UserDashboardStore
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(1..<5) { index in
                            Image("image\(index)")
                                .resizable()
                                .frame(width: 320, height: 160)
                                .cornerRadius(5)
                                .shadow(radius: 5)
                        }
                    }
                }
                Spacer().frame(height: 30)
            }
        }
    }
}
