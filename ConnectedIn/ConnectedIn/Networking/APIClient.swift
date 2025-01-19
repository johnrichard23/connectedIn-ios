import Foundation
import Amplify
import Combine

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case authenticationError(String)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .authenticationError(let message):
            return "Authentication error: \(message)"
        }
    }
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = AWSConfig.apiUrl
    private let tokenProvider: AuthCognitoTokensProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(tokenProvider: AuthCognitoTokensProvider = AmplifyAuthTokenProvider()) {
        self.tokenProvider = tokenProvider
    }
    
    func requestPublisher<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) -> AnyPublisher<T, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            Task {
                do {
                    let result: T = try await self.request(endpoint: endpoint, method: method, body: body)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    // Async/await request method
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        // Get the auth token
        let idToken = try await tokenProvider.getIdToken()
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: nil))
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Optional: handle snake_case from backend
                return try decoder.decode(T.self, from: data)
            } catch {
                print("❌ Decoding error: \(error)")
                throw APIError.decodingError(error)
            }
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    // Helper method for creating URLRequest
    private func createRequest(
        url: URL,
        method: String,
        body: Data?,
        token: String
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
