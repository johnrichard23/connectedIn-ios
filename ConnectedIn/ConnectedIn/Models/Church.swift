//
//  Church.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 7/19/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct ChurchResponse: Codable {
    let churches: [Church]
}

struct Church: Codable, Identifiable, Equatable {
    
    let id: String
    let name: String
    let description: String
    let avatarUrl: String
    let shortDescription: String
    let latitude: Double
    let longitude: Double
    let phone: String
    let email: String
    let address: String
    let countryGroup: String
    let facebookUrl: String
    let instagramUrl: String
    let serviceTimes: [String]
    let region: String
    let photos: [String]
    let donations: Donations
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var avatarImage: Image {
        if let url = URL(string: avatarUrl), url.scheme != nil {
            // It's a valid URL, use AsyncImage in the view
            return Image(systemName: "photo") // Placeholder
        } else {
            // It's a local image name
            return Image(avatarUrl)
        }
    }
}

struct SocialLinks: Codable, Equatable {
    let facebookUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case facebookUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlString = try container.decode(String.self, forKey: .facebookUrl)
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorruptedError(forKey: .facebookUrl, in: container, debugDescription: "Invalid URL string")
        }
        self.facebookUrl = url
    }
}

struct Donations: Codable, Equatable {
    let gcashNumber: String
    let bankAccount: BankAccount
}

struct BankAccount: Codable, Equatable {
    let accountNumber: String
    let bankName: String
}

struct TestChurch {
    let id: Int
    let name: String
    let imageUrl: String
}

// Helper extension for Church model
extension Church {
    var hasSocialMedia: Bool {
        return facebookUrl != nil || instagramUrl != nil
    }
}
