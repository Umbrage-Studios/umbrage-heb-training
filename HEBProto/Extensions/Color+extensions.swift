//
//  Color+extensions.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

extension Color {
    static var dust: Color {
        let hexFloat: CGFloat = 217 / 255
        return Color(UIColor(red: hexFloat, green: hexFloat, blue: hexFloat, alpha: 1.0))
    }
    
    static var systemBackground: Color {
        Color(UIColor.systemBackground)
    }
}
