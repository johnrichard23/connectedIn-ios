//
//  RoundUpGivingView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct RoundUpGivingView: View {
    @StateObject private var viewModel = RoundUpViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.black)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.connectedInMain)]
        appearance.backgroundColor = UIColor(Color.connectedInHomeBG)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
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
                .scrollContentBackground(.hidden)
                .tint(Color.connectedInMain)
                .padding(.top, 5)
            }
            .navigationTitle("Round Up Giving")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(color)]
        return self
    }
}

//#Preview {
//    RoundUpGivingView()
//}
