//
//  Missionary.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import Foundation

struct MissionaryResponse: Codable {
    let missionaries: [Missionary]
}

struct Missionary: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let location: String
    let avatarUrl: String
    let phone: String
    let email: String
    let facebookUrl: String
    let instagramUrl: String
    let photos: [String]
    let donations: MissionaryDonations
}

struct MissionaryDonations: Codable, Equatable {
    let gcashNumber: String
    let bankAccount: MissionaryBankAccount
}

struct MissionaryBankAccount: Codable, Equatable {
    let accountNumber: String
    let bankName: String
}
