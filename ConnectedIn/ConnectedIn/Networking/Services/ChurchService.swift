//
//  ChurchService.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/18/24.
//

import Foundation
import Combine

protocol ChurchServiceProtocol {
    func fetchChurches() -> AnyPublisher<[Church], Error>
    func fetchChurchesLocalData() -> AnyPublisher<[Church], Error>
    func createChurch(_ church: Church) -> AnyPublisher<Church, Error>
    func updateChurch(_ church: Church) -> AnyPublisher<Church, Error>
    func getChurch(id: String) -> AnyPublisher<Church, Error>
}

protocol MockChurchServiceProtocol {
//    func fetchNearbyChurches(latitude: Double, longitude: Double, completion: @escaping (Result<[Church], Error>) -> Void)
}

class ChurchService: ChurchServiceProtocol, ObservableObject {
    static let shared = ChurchService()
    private let apiClient = APIClient.shared
    private let session: URLSession
    private var hasLoadedChurches = false
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var cachedChurches: [Church] = []
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchChurches() -> AnyPublisher<[Church], Error> {
        return Future { promise in
            Task {
                do {
                    let response: ChurchResponse = try await self.apiClient.request(endpoint: "/churches")
                    
                    // Cache the churches for offline use
                    self.cachedChurches = response.churches
                    self.hasLoadedChurches = true
                    
                    promise(.success(response.churches))
                } catch let error as APIError {
                    print("❌ API Error: \(error.message)")
                    
                    // If API fails, try to use cached data
                    if !self.cachedChurches.isEmpty {
                        print("📱 Using cached churches data")
                        promise(.success(self.cachedChurches))
                    } else {
                        // If no cached data, try local mock data
                        print("📄 Falling back to local mock data")
                        self.fetchChurchesLocalData()
                            .sink(
                                receiveCompletion: { completion in
                                    if case .failure(let error) = completion {
                                        promise(.failure(error))
                                    }
                                },
                                receiveValue: { churches in
                                    promise(.success(churches))
                                }
                            )
                            .store(in: &self.cancellables)
                    }
                } catch {
                    print("❌ Unknown error: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createChurch(_ church: Church) -> AnyPublisher<Church, Error> {
        return Future { promise in
            Task {
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(church)
                    let createdChurch: Church = try await self.apiClient.request(
                        endpoint: "/churches",
                        method: "POST",
                        body: data
                    )
                    promise(.success(createdChurch))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateChurch(_ church: Church) -> AnyPublisher<Church, Error> {
        return Future { promise in
            Task {
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(church)
                    let updatedChurch: Church = try await self.apiClient.request(
                        endpoint: "/churches/\(church.id)",
                        method: "PUT",
                        body: data
                    )
                    promise(.success(updatedChurch))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getChurch(id: String) -> AnyPublisher<Church, Error> {
        return Future { promise in
            Task {
                do {
                    let church: Church = try await self.apiClient.request(endpoint: "/churches/\(id)")
                    promise(.success(church))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Keep the local data method for testing/offline functionality
    func fetchChurchesLocalData() -> AnyPublisher<[Church], Error> {
        
        if hasLoadedChurches {
            return Just(cachedChurches)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard let url = Bundle.main.url(forResource: "MockChurchResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "MockChurchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load mock data"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .decode(type: ChurchResponse.self, decoder: JSONDecoder())
            .map(\.churches)
            .eraseToAnyPublisher()
    }
}


class MockChurchService: MockChurchServiceProtocol {
    
//    private let sampleChurches: [Church] = [
//                Church(
//                    id: "1",
//                    name: "FFBC Sorsogon",
//                    description: "A vibrant church community committed to serving God through worship, outreach, and fellowship. Known for its active participation in local outreach programs and support for the underprivileged.",
//                    avatarUrl: "image1",
//                    shortDescription: "Historic cathedral",
//                    latitude: 14.5995,
//                    longitude: 120.9842,
//                    phone: "+63 912 345 6789",
//                    email: "ffbc.sorsogon@example.com",
//                    address: "Rizal St. Piot, Sorsogon City",
//                    countryGroup: "Luzon",
//                    facebookUrl: "https://facebook.com/ffbcsorsogon",
//                    instagramUrl: "https://instagram.com/ffbcsorsogon",
//                    serviceTimes: ["Sunday 8:00 AM", "Sunday 10:30 AM", "Wednesday 7:00 PM"],
//                    region: "San Francisco",
//                    photos: ["church1", "church2", "church3", "church4", "church5", "church6"],
//                    donations: Donations(
//                        gcashNumber: "1234567890",
//                        bankAccount: BankAccount(accountNumber: "987654321", bankName: "Sample Bank")
//                    )
//                ),
//                Church(
//                    id: "2",
//                    name: "Grace Community Church",
//                    description: "A welcoming community church",
//                    avatarUrl: "https://example.com/grace_community.jpg",
//                    shortDescription: "Community church",
//                    latitude: 37.7739,
//                    longitude: -122.4312,
//                    phone: "+1 415 555 0123",
//                    email: "info@gracecommunity.org",
//                    address: "3980 24th St, San Francisco, CA 94114",
//                    countryGroup: "Mindanao",
//                    facebookUrl: "https://facebook.com/gracecommunity",
//                    instagramUrl: "https://instagram.com/gracecommunity",
//                    serviceTimes: ["Sunday 9:00 AM", "Sunday 11:00 AM"],
//                    region: "San Francisco",
//                    photos: ["church1", "church2", "church3", "church4", "church5", "church6"],
//                    donations: Donations(
//                        gcashNumber: "0987654321",
//                        bankAccount: BankAccount(accountNumber: "123456789", bankName: "Community Bank")
//                    )
//                ),
//                Church(
//                    id: "3",
//                    name: "First Baptist Church",
//                    description: "A historic Baptist church",
//                    avatarUrl: "https://example.com/first_baptist.jpg",
//                    shortDescription: "Baptist church",
//                    latitude: 37.7831,
//                    longitude: -122.4159,
//                    phone: "+1 415 555 0456",
//                    email: "contact@firstbaptist.org",
//                    address: "1100 Polk St, San Francisco, CA 94109",
//                    countryGroup: "Visayas",
//                    facebookUrl: "https://facebook.com/firstbaptist",
//                    instagramUrl: "https://instagram.com/firstbaptist",
//                    serviceTimes: ["Sunday 8:30 AM", "Sunday 11:00 AM", "Sunday 6:00 PM"],
//                    region: "San Francisco",
//                    photos: ["church1", "church2", "church3", "church4", "church5", "church6"],
//                    donations: Donations(
//                        gcashNumber: "5678901234",
//                        bankAccount: BankAccount(accountNumber: "345678901", bankName: "First Bank")
//                    )
//                )
//            ]
    
//    func fetchNearbyChurches(latitude: Double, longitude: Double, completion: @escaping (Result<[Church], Error>) -> Void) {
//        // Simulate network delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            // In a real implementation, you would filter churches based on proximity to the given coordinates
//            // For this mock, we'll just return all sample churches
//            completion(.success(self.sampleChurches))
//        }
//    }
    
    func fetchChurchesLocalData() -> AnyPublisher<[Church], any Error> {
        guard let url = Bundle.main.url(forResource: "MockChurchResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "MockChurchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load mock data"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .decode(type: ChurchResponse.self, decoder: JSONDecoder())
            .map(\.churches)
            .eraseToAnyPublisher()
    }
    
//    func fetchChurches() -> AnyPublisher<[Church], Error> {
//        guard let url = Bundle.main.url(forResource: "MockChurchResponse", withExtension: "json"),
//              let data = try? Data(contentsOf: url) else {
//            return Fail(error: NSError(domain: "MockChurchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load mock data"]))
//                .eraseToAnyPublisher()
//        }
//        
//        return Just(data)
//            .decode(type: ChurchResponse.self, decoder: JSONDecoder())
//            .map(\.churches)
//            .eraseToAnyPublisher()
//    }
}
