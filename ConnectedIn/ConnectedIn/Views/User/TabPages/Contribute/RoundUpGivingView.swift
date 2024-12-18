//
//  RoundUpGivingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct RoundUpGivingView: View {
    @StateObject private var viewModel = RoundUpViewModel()
    
    var body: some View {
        ZStack {
            // Main background
            Color.connectedInHomeBG
                .ignoresSafeArea()
            
            Form {
                Section {
                    Toggle("Enable Round Up Giving", isOn: $viewModel.isEnabled)
                        .foregroundStyle(.gray)
                        .listRowInsets(EdgeInsets(
                            top: 8,
                            leading: 16,
                            bottom: 8,
                            trailing: 16
                        ))
                    
                    if viewModel.isEnabled {
                        Picker("Select Recipient", selection: $viewModel.selectedRecipientId) {
                            ForEach(viewModel.availableRecipients) { recipient in
                                Text(recipient.name)
                                    .foregroundStyle(.gray)
                                    .tag(recipient.id)
                            }
                        }
                        .foregroundStyle(.gray)
                        .listRowInsets(EdgeInsets(
                            top: 8,
                            leading: 16,
                            bottom: 8,
                            trailing: 16
                        ))
                    }
                }
                .listRowBackground(Color.white)
                
                Section("How it works") {
                    Text("When you make a purchase, we'll round up to the nearest peso and donate the difference to your selected recipient.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .listRowInsets(EdgeInsets(
                            top: 8,
                            leading: 16,
                            bottom: 8,
                            trailing: 16
                        ))
                }
                .listRowBackground(Color.white)
                
                if viewModel.isEnabled {
                    Section("Recent Round Ups") {
                        ForEach(viewModel.recentRoundUps) { roundUp in
                            RoundUpRowView(roundUp: roundUp)
                                .listRowInsets(EdgeInsets(
                                    top: 8,
                                    leading: 16,
                                    bottom: 8,
                                    trailing: 16
                                ))
                        }
                    }
                    .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden) // Hide default Form background
            .tint(Color.connectedInMain)
            .padding(.top, 5)
        }
        .navigationTitle("Round Up Giving")
        .toolbarColorScheme(.light, for: .navigationBar) // For black text
        .toolbarBackground(Color.connectedInHomeBG, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

//#Preview {
//    RoundUpGivingView()
//}
