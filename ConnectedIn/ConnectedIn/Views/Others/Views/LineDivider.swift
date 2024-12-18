//
//  LineDivider.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/20/24.
//

import SwiftUI

struct LineDivider: View {
    var color: Color
    var height: CGFloat?
    var width: CGFloat?
    
    var body: some View {
        Rectangle().fill(color).frame(width: width, height: height)
    }
}
