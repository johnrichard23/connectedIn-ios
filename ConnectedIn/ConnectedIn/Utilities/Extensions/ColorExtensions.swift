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
}
