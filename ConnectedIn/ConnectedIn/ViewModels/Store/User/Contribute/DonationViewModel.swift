//
//  DonationViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import Foundation

@MainActor
class DonationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedAmount: Double = 0
    @Published var selectedPaymentMethod: PaymentMethod = .gcash
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let recipient: any Recipient
    
    // MARK: - Computed Properties
    var recipientName: String {
        recipient.name
    }
    
    var recipientType: String {
        switch recipient {
        case is Church:
            return "Church"
        case is Missionary:
            return "Missionary"
        case is Ministry:
            return "Ministry"
        default:
            return "Organization"
        }
    }
    
    var isValidDonation: Bool {
        selectedAmount >= 100 && selectedAmount <= 50000
    }
    
    // MARK: - Initialization
    init(recipient: any Recipient) {
        self.recipient = recipient
    }
    
    // MARK: - Methods
    func processDonation() async {
        do {
            // Simulate API call
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            // Simulate success
            await MainActor.run {
                showSuccessAlert = true
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}
