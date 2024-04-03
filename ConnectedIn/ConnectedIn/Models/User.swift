//
//  User.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import Foundation

enum UserStatus: String {
    case STATUS_ACTIVE = "active"
    case STATUS_INACTIVE = "inactive"
}

struct UserRole: Codable, Hashable {
    var id: Int
    var email: String
    var role: String
}

struct User: Codable {
    var userID: Int?
    var email: String
    var firstName: String?
    var lastName: String?
    var role: UserRole?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case email
        case firstName
        case lastName
        case role
    }
    
    func toJsonString() -> String {
        var jsonString = String()
        do {
            let encodedData = try JSONEncoder().encode(self)
            jsonString = String(data: encodedData,
                                encoding: .utf8)!
            
        } catch {
            print("error converting Codable to JSON String", error)
        }
        return jsonString
    }
}

struct PendingUser: Codable {
    var email: String
    var approved: Bool = false
}

func DummyConnectedInUser() -> User {
    User(userID: 123,
         email: "john_doe@mail.com",
         firstName: "John",
         lastName: "Doe",
         role: UserRole(id: 5, email: "john_doe@mail.com", role: "doctor")
         )
}

struct Tokens: Codable {
    var idToken: String
    var accessToken: String
    var refreshToken: String
}
