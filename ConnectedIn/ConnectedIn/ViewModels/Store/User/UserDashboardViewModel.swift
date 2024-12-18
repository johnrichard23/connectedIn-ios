//
//  UserDashboardViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 5/3/24.
//

import Foundation
import Combine
import Amplify

final class UserDashboardViewModel: ObservableObject {
    
    @Published var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
    }
}
