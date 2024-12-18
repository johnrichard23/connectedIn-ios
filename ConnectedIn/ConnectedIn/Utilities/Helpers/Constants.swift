//
//  Constants.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/18/24.
//

import Foundation

struct Constants {
    
    enum APIError: String, LocalizedError {
        case notFound = "Not Found: 404"
        case invalidURL = "The URL is invalid"
        case badRequest = "Bad Request: 400"
        case parsingError = "JSON parsing Error"
        case dataNotFound = "Data not Found"
    }
    
    static let countryGroups = ["Luzon", "Visayas", "Mindanao"]
    static let regions = [
        "Luzon": ["NCR", "CAR", "Ilocos", "Central Luzon", "CALABARZON", "MIMAROPA", "Bicol"],
        "Visayas": ["Western Visayas", "Central Visayas", "Eastern Visayas"],
        "Mindanao": ["Zamboanga Peninsula", "Northern Mindanao", "Davao", "SOCCSKSARGEN", "CARAGA", "BARMM"]
    ]
    
    
}
