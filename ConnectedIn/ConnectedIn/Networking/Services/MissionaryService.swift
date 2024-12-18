//
//  MissionaryService.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/5/24.
//

import Foundation
import Combine

protocol MissionaryServiceProtocol {
    func fetchMissionaries() -> AnyPublisher<[Missionary], Error>
    func fetchMissionariesLocalData() -> AnyPublisher<[Missionary], Error>
}

protocol MockMissionariesServiceProtocol {
    func fetchNearbyMissionaries(latitude: Double, longitude: Double, completion: @escaping (Result<[Missionary], Error>) -> Void)
}

class MissionaryService: MissionaryServiceProtocol {
    private let baseURL = URL(string: "https://api.example.com")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMissionaries() -> AnyPublisher<[Missionary], any Error> {
        let url = baseURL.appendingPathComponent("missionary")
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MissionaryResponse.self, decoder: JSONDecoder())
            .map(\.missionaries)
            .eraseToAnyPublisher()
    }
    
    func fetchMissionariesLocalData() -> AnyPublisher<[Missionary], any Error> {
        guard let url = Bundle.main.url(forResource: "MockMissionaryResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "MockMissionaryService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load mock data"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .decode(type: MissionaryResponse.self, decoder: JSONDecoder())
            .map(\.missionaries)
            .eraseToAnyPublisher()
    }
}
