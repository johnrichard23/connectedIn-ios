//
//  Recipient.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import Foundation

protocol Recipient: Identifiable {
    var id: String { get }
    var name: String { get }
    var gcashNumber: String { get }
    var bankAccount: BankAccountInfo { get }
}

protocol BankAccountInfo {
    var accountNumber: String { get }
    var bankName: String { get }
}

// Conform existing bank account types
extension BankAccount: BankAccountInfo {}
extension MissionaryBankAccount: BankAccountInfo {}
extension MinistryBankAccount: BankAccountInfo {}

// Conform existing models to Recipient
extension Church: Recipient {
    var gcashNumber: String { donations.gcashNumber }
    var bankAccount: BankAccountInfo { donations.bankAccount }
}

extension Missionary: Recipient {
    var gcashNumber: String { donations.gcashNumber }
    var bankAccount: BankAccountInfo { donations.bankAccount }
}

extension Ministry: Recipient {
    var gcashNumber: String { donations.gcashNumber }
    var bankAccount: BankAccountInfo { donations.bankAccount }
}

enum PaymentMethod: String, CaseIterable {
    case gcash = "GCash"
    case bank = "Bank Transfer"
}
