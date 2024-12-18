//
//  CustomCornerShape.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/4/24.
//

import SwiftUI

struct CustomCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
