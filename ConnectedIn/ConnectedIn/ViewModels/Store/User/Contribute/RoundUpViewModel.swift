//
//  RoundUpViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import Foundation
import Combine

import Foundation
import Combine

@MainActor
class RoundUpViewModel: ObservableObject {
    @Published var isEnabled: Bool = false
    @Published var selectedRecipientId: String = ""
    @Published var availableRecipients: [RecipientWrapper] = []
    @Published var recentRoundUps: [RoundUp] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadPreferences()
        fetchRecipients()
        fetchRecentRoundUps()
    }
    
    private func loadPreferences() {
        isEnabled = UserDefaults.standard.bool(forKey: "roundUpEnabled")
        selectedRecipientId = UserDefaults.standard.string(forKey: "selectedRecipientId") ?? ""
    }
    
    private func fetchRecipients() {
        // Simulate fetching recipients
        let church = Church(
            id: "1",
            name: "Local Church",
            description: "A local church",
            avatarUrl: "https://example.com/church.jpg",
            shortDescription: "A welcoming community",
            latitude: 14.5995,
            longitude: 120.9842,
            phone: "+63 123 456 7890",
            email: "info@localchurch.org",
            address: "123 Main St, Manila",
            countryGroup: "Luzon",
            facebookUrl: "https://facebook.com/localchurch",
            instagramUrl: "https://instagram.com/localchurch",
            serviceTimes: ["Sunday 9:00 AM", "Sunday 11:00 AM"],
            region: "NCR",
            photos: ["photo1.jpg", "photo2.jpg"],
            donations: Donations(
                gcashNumber: "09123456789",
                bankAccount: BankAccount(
                    accountNumber: "1234567890",
                    bankName: "BDO"
                )
            )
        )
        
        let missionary = Missionary(
            id: "2",
            name: "John Smith",
            description: "Serving in Bible translation ministry",
            location: "Thailand",
            avatarUrl: "https://example.com/missionary.jpg",
            phone: "+63 987 654 3210",
            email: "john@mission.org",
            facebookUrl: "https://facebook.com/johnsmith",
            instagramUrl: "https://instagram.com/johnsmith",
            photos: ["photo1.jpg", "photo2.jpg"],
            donations: MissionaryDonations(
                gcashNumber: "09987654321",
                bankAccount: MissionaryBankAccount(
                    accountNumber: "0987654321",
                    bankName: "BPI"
                )
            )
        )
        
        let ministry = Ministry(
            id: "3",
            name: "Youth Ministry",
            description: "Reaching young people for Christ",
            location: "Manila",
            avatarUrl: "https://example.com/ministry.jpg",
            phone: "+63 456 789 0123",
            email: "youth@ministry.org",
            facebookUrl: "https://facebook.com/youthministry",
            instagramUrl: "https://instagram.com/youthministry",
            photos: ["photo1.jpg", "photo2.jpg"],
            donations: MinistryDonations(
                gcashNumber: "09456789123",
                bankAccount: MinistryBankAccount(
                    accountNumber: "4567891230",
                    bankName: "UnionBank"
                )
            )
        )
        
        availableRecipients = [
            RecipientWrapper(recipient: church),
            RecipientWrapper(recipient: missionary),
            RecipientWrapper(recipient: ministry)
        ]
    }
    
    private func fetchRecentRoundUps() {
        // Simulate fetching recent round ups
        recentRoundUps = [
            RoundUp(id: "1", amount: 0.75, originalAmount: 9.25, date: Date()),
            RoundUp(id: "2", amount: 0.50, originalAmount: 4.50, date: Date().addingTimeInterval(-86400)),
            RoundUp(id: "3", amount: 0.25, originalAmount: 2.75, date: Date().addingTimeInterval(-172800))
        ]
    }
}

// MARK: - Helper Types
struct RecipientWrapper: Identifiable {
    let recipient: any Recipient
    
    var id: String { recipient.id }
    var name: String { recipient.name }
    var gcashNumber: String { recipient.gcashNumber }
    var bankAccount: BankAccountInfo { recipient.bankAccount }
}
