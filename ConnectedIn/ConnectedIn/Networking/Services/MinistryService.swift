//
//  MinistryService.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/6/24.
//

import Foundation

import Foundation
import Combine

protocol MinistryServiceProtocol {
    func fetchMinistries() -> AnyPublisher<[Ministry], Error>
    func fetchMinistriesLocalData() -> AnyPublisher<[Ministry], Error>
}

protocol MockMinistriesServiceProtocol {
    func fetchNearbyMinistries(latitude: Double, longitude: Double, completion: @escaping (Result<[Ministry], Error>) -> Void)
}

class MinistryService: MinistryServiceProtocol {
    private let baseURL = URL(string: "https://api.example.com")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMinistries() -> AnyPublisher<[Ministry], any Error> {
        let url = baseURL.appendingPathComponent("ministry")
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MinistryResponse.self, decoder: JSONDecoder())
            .map(\.ministries)
            .eraseToAnyPublisher()
    }
    
    func fetchMinistriesLocalData() -> AnyPublisher<[Ministry], any Error> {
        guard let url = Bundle.main.url(forResource: "MockMinistryResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "MockMinistryService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load mock data"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .decode(type: MinistryResponse.self, decoder: JSONDecoder())
            .map(\.ministries)
            .eraseToAnyPublisher()
    }
}
