//
//  MissionaryViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/5/24.
//

import Foundation
import Combine

class MissionaryViewModel: ObservableObject {
    @Published var missionaries: [Missionary] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let service: MissionaryServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: MissionaryServiceProtocol = MissionaryService()) {
        self.service = service
    }
    
    func fetchMissionaries() {
        isLoading = true
        error = nil
        
        service.fetchMissionariesLocalData()
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
            } receiveValue: { [weak self] missionaries in
                print("Debug: Received \(missionaries.count) missionaries")
                self?.missionaries = missionaries
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
