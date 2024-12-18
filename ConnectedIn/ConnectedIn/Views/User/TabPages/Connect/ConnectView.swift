//
//  ConnectView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/7/24.
//

import SwiftUI

struct ConnectView: View {
    
    @StateObject private var locationsViewModel = LocationsViewModel()
    @StateObject private var churchViewModel = ChurchViewModel()
    
    
    var body: some View {
        ChurchesLocationView(viewModel: locationsViewModel, churches: churchViewModel.churches)
            .onAppear {
                churchViewModel.fetchChurches()
        }
    }
}
