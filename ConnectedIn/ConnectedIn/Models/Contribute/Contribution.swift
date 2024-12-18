//
//  Contribution.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 9/30/24.
//

import Foundation

struct Contribution: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var date: String
    var category: ContributionCategory
}

enum ContributionCategory: String, CaseIterable {
    case church = "Church"
    case missionaries = "Missionaries"
    case community = "Community Ministries"
}

struct Campaign: Identifiable {
    var id = UUID()
    var title: String
    var goalAmount: Double
    var currentAmount: Double
    var category: String
}
