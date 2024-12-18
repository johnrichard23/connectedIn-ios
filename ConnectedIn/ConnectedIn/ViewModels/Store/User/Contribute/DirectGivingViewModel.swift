//
//  DirectGivingViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import Foundation
import Combine

@MainActor
class DirectGivingViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var churches: [Church]
    @Published private(set) var missionaries: [Missionary]
    @Published private(set) var ministries: [Ministry]
    
    // MARK: - Initialization
    init(
        churches: [Church] = [],
        missionaries: [Missionary] = [],
        ministries: [Ministry] = []
    ) {
        self.churches = churches
        self.missionaries = missionaries
        self.ministries = ministries
    }
    
    // MARK: - Public Methods
    func refresh() async {
        do {
            // Implement your actual data fetching logic here
            // For now, we'll just use the existing data
            // Example:
            // let newChurches = try await churchRepository.fetchChurches()
            // await MainActor.run { churches = newChurches }
        } catch {
            // Handle error appropriately
            print("Error refreshing data: \(error)")
        }
    }
}
