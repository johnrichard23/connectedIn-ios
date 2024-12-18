//
//  MinistryViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/6/24.
//

import Foundation
import Combine

class MinistryViewModel: ObservableObject {
    @Published var ministries: [Ministry] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let service: MinistryServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: MinistryServiceProtocol = MinistryService()) {
        self.service = service
    }
    
    func fetchMinistries() {
        isLoading = true
        error = nil
        
        service.fetchMinistriesLocalData()
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
            } receiveValue: { [weak self] ministries in
                print("Debug: Received \(ministries.count) ministries")
                self?.ministries = ministries
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
