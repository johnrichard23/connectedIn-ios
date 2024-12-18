//
//  UserTabStore.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/19/24.
//

import Foundation

enum UserTab: String {
    case home = "Home"
    case connect = "Connect"
    case contribute = "Contribute"
    case profile = "Profile"
}

struct UserTabBarPage: Identifiable {
    var id = UUID()
    var icon: String
    var tag: UserTab
    var text: String
}

final class UserTabStore: ObservableObject {
    @Published var activeTab = UserTab.home
}
