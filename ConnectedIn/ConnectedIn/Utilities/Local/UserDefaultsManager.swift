//
//  UserDefaultsManager.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 6/10/24.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private var user: User?
    
    let userKey = "USER_KEY"
    let pendingUserKey = "PENDING_USER_KEY"
    let connectedInUserKey = "CONNECTEDIN_USER_KEY"
    let connectedInTokenKey = "CONNECTEDIN_TOKEN_KEY"
    let connectedInDeviceToken = "CONNECTEDIN_DEVICE_TOKEN_KEY"

    let defaults = UserDefaults.standard


}

extension UserDefaultsManager {
    
    // CRUD
    func saveUser(user: LocalUser) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: userKey)
            defaults.synchronize()
        }
    }
    
    func getUser() -> LocalUser? {
        if let savedPerson = defaults.object(forKey: userKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LocalUser.self, from: savedPerson) {
                print(loadedPerson.email)
                return loadedPerson
            }
        }
        return nil
    }
    
    func deleteUser() {
        defaults.removeObject(forKey: userKey)
        defaults.synchronize()
    }
    
    // CRUD
    func savePendingUser(user: PendingUser) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: pendingUserKey)
            defaults.synchronize()
        }
    }
    
    func getPendingUser() -> PendingUser? {
        if let savedPerson = defaults.object(forKey: pendingUserKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(PendingUser.self, from: savedPerson) {
                print(loadedPerson.email)
                return loadedPerson
            }
        }
        return nil
    }
    
    func deletePendingUser() {
        defaults.removeObject(forKey: pendingUserKey)
        defaults.synchronize()
    }
    
    
    
    // CRUD
    func saveConnectedInUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: connectedInUserKey)
            defaults.synchronize()
        }
    }

    func saveDeviceToken(token: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(token) {
            defaults.set(encoded, forKey: connectedInDeviceToken)
            defaults.synchronize()
        }
    }
    
    func getConnectedInUser() -> User? {
        if let savedPerson = defaults.object(forKey: connectedInUserKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                print(loadedPerson.email)
                return loadedPerson
            }
        }
        return nil
    }
    
    func deleteConnectedInUser() {
        defaults.removeObject(forKey: connectedInUserKey)
        defaults.synchronize()
    }
    
    func saveTokens(tokens: Tokens) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tokens) {
            defaults.set(encoded, forKey: connectedInTokenKey)
            defaults.synchronize()
        }
    }
    
    func getTokens() -> Tokens? {
        if let savedTokens = defaults.object(forKey: connectedInTokenKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedTokens = try? decoder.decode(Tokens.self, from: savedTokens) {
                print(loadedTokens.idToken)
                return loadedTokens
            }
        }
        return nil
    }
    
    func getDeviceTokens() -> String? {
        if let savedTokens = defaults.object(forKey: connectedInTokenKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedTokens = try? decoder.decode(String.self, from: savedTokens) {
                return loadedTokens
            }
        }
        return nil
    }
    
    func deleteTokens() {
        defaults.removeObject(forKey: connectedInUserKey)
        defaults.synchronize()
    }
    

    
}

