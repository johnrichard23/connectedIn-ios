//
//  Ministry.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import Foundation

import Foundation

struct MinistryResponse: Codable {
    let ministries: [Ministry]
}

struct Ministry: Codable, Identifiable, Equatable {
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
    let donations: MinistryDonations
}

struct MinistryDonations: Codable, Equatable {
    let gcashNumber: String
    let bankAccount: MinistryBankAccount
}

struct MinistryBankAccount: Codable, Equatable {
    let accountNumber: String
    let bankName: String
}
