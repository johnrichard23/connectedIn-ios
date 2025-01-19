//
//  DirectGivingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct DirectGivingView: View {
    @StateObject private var viewModel: DirectGivingViewModel
    
    init(
        churches: [Church],
        missionaries: [Missionary],
        ministries: [Ministry]
    ) {
        _viewModel = StateObject(wrappedValue: DirectGivingViewModel(
            churches: churches,
            missionaries: missionaries,
            ministries: ministries
        ))
    }
    
    var body: some View {
        List {
            if !viewModel.churches.isEmpty {
                Section("Churches") {
                    ForEach(viewModel.churches) { church in
                        NavigationLink {
                            DonationView(recipient: church)
                        } label: {
                            ChurchRowView(church: church)
                        }
                    }
                }
            }
            
            if !viewModel.missionaries.isEmpty {
                Section("Missionaries") {
                    ForEach(viewModel.missionaries) { missionary in
                        NavigationLink {
                            DonationView(recipient: missionary)
                        } label: {
                            MissionaryRowView(missionary: missionary)
                        }
                    }
                }
            }
            
            if !viewModel.ministries.isEmpty {
                Section("Ministries") {
                    ForEach(viewModel.ministries) { ministry in
                        NavigationLink {
                            DonationView(recipient: ministry)
                        } label: {
                            MinistryRowView(ministry: ministry)
                        }
                    }
                }
            }
        }
        .navigationTitle("Direct Giving")
        .toolbarColorScheme(.light, for: .navigationBar)
        .background(Color.connectedInHomeBG)
        .listStyle(.insetGrouped)
    }
}

//#Preview {
//    DirectGivingView()
//}
