//
//  ContributionService.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 9/30/24.
//

import Foundation
import Combine

class ContributionService {
    
    static let shared = ContributionService()
    
    func fetchContributions() -> Future<[Contribution], Error> {
        return Future { promise in
        
            let dummyContributions = [
                Contribution(name: "FFBC Sorsogon", amount: 500, date: "Sep 28, 2024", category: .church),
                Contribution(name: "Manila Baptist Church", amount: 300, date: "Sep 4, 2024", category: .church),
                Contribution(name: "David Brainerd", amount: 250, date: "Sep 25, 2024", category: .missionaries),
                Contribution(name: "CrossDrive Missions", amount: 1000, date: "Sep 10, 2024", category: .community)
            ]
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success(dummyContributions))
            }
        }
    }
    
    // Simulate making a contribution
    func makeContribution(amount: Double) -> Future<Bool, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success(true)) // Simulate success
            }
        }
    }
}
