//
//  AuthViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 9/25/24.
//

import Foundation
import Amplify
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    var cancellables = Set<AnyCancellable>()
    
    func login(username: String, password: String) {
        
        // Create a future publisher for the async 'signIn' method
        Future<AuthSignInResult, Error> { promise in
            Task {
                do {
                    let result = try await Amplify.Auth.signIn(username: username, password: password)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            case .finished:
                break
            }
        } receiveValue: { result in
            self.isAuthenticated = result.isSignedIn
        }
        .store(in: &cancellables)
    }
    
    
}
