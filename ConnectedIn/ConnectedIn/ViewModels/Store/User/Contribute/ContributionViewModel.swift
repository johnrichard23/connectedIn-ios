//
//  ContributionViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/1/24.
//

import Foundation
import Combine

class ContributionViewModel: ObservableObject {
    
    @Published var contributions: [Contribution] = []
    @Published var churchContributions: [Contribution] = []
    @Published var missionariesContributions: [Contribution] = []
    @Published var communityContributions: [Contribution] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchContributions()
    }
    
    func fetchContributions() {
        isLoading = true
        ContributionService.shared.fetchContributions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] contributions in
                self?.contributions = contributions
                self?.categorizeContributions(contributions)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func categorizeContributions(_ contributions: [Contribution]) {
        self.churchContributions = contributions.filter { $0.category == .church}
        self.missionariesContributions = contributions.filter { $0.category == .missionaries}
        self.communityContributions = contributions.filter { $0.category == .community}
    }
    
    // Make a Contribution
    func makeContribution(amount: Double) {
        isLoading = true
        ContributionService.shared.makeContribution(amount: amount)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] success in
                if success {
                    self?.fetchContributions() // Refresh contributions after a successful contribution
                }
            })
            .store(in: &cancellables)
    }
}
