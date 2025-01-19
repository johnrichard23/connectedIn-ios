 import Foundation
import Combine

@MainActor
class ChurchViewModel: ObservableObject {
    @Published var churches: [Church] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let churchService: ChurchService
    
    init(churchService: ChurchService = ChurchService.shared) {
        self.churchService = churchService
    }
    
    func fetchChurches() {
        isLoading = true
        error = nil
        
        churchService.fetchChurches()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                    print("❌ Error fetching churches:", error)
                }
            } receiveValue: { [weak self] churches in
                self?.churches = churches
                print("✅ Fetched \(churches.count) churches")
                churches.forEach { church in
                    print("Church: \(church.name)")
                }
            }
            .store(in: &cancellables)
    }
    
    func testFetchChurches() {
        Task {
            do {
                let response: ChurchResponse = try await APIClient.shared.request(endpoint: "/churches")
                print("✅ Churches Response:", response)
                print("Number of churches:", response.churches.count)
                response.churches.forEach { church in
                    print("Church:", church)
                }
            } catch {
                print("❌ Error fetching churches:", error)
                if let apiError = error as? APIError {
                    print("API Error:", apiError.message)
                }
 