//
//  ChurchViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/18/24.
//

import Foundation
import Combine

class ChurchViewModel: ObservableObject {
    @Published var churches: [Church] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let service: ChurchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ChurchServiceProtocol = ChurchService()) {
        self.service = service
    }
    
    func fetchChurches() {
        isLoading = true
        error = nil
        
        service.fetchChurchesLocalData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let fetchError):
                    print("Debug: Fetch failed with error: \(fetchError)")
                    print("Debug: Error type: \(type(of: fetchError))")
                    print("Debug: Error description: \(fetchError.localizedDescription)")
                    self?.error = fetchError
                }
            } receiveValue: { [weak self] churches in
                print("Debug: Received \(churches.count) churches")
                self?.churches = churches
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

extension ChurchViewModel {
    func churchesByRegion(_ region: String) -> [Church] {
        churches.filter { $0.region == region}
    }
    
    var luzonChurches: [Church] {
        churchesByRegion("Luzon")
    }
    
    var visayasChurches: [Church] {
        churchesByRegion("Visayas")
    }
}
