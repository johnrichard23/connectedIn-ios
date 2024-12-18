//
//  ColorExtensions.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/1/24.
//

import Foundation
import SwiftUI

extension Color{
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static let connectedInMain = Color(hex: 0x199779, opacity: 1.0)
    static let connectedInFB = Color(hex: 0x4267B2, opacity: 1.0)
    static let connectedInRed = Color(hex: 0x971921, opacity: 1.0)
    static let connectedInHomeBG = Color(hex: 0xF6F4F4, opacity: 1.0)
    static let connectedInCommunityCardBG = Color(hex: 0xc8dae7, opacity: 1.0)
    static let connectedTopHeaderBG = Color(hex: 0xc8dae7, opacity: 1.0)
    
    static let lightGray = Color(hex: 0xE0E0E0, opacity: 1.0)
    static let softBeige = Color(hex: 0xF0E6D6, opacity: 1.0)
    static let darkGray = Color(hex: 0x333333, opacity: 1.0)
    
    static let dashboardHeaderColor = Color(red: 54/255, green: 112/255, blue: 110/255)
    
}
