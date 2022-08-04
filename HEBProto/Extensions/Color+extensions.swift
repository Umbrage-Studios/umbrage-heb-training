//
//  Color+extensions.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

extension Color {
    static var dust: Color {
        let rgbFloat: CGFloat = 217 / 255
        return Color(UIColor(red: rgbFloat, green: rgbFloat, blue: rgbFloat, alpha: 1.0))
    }
    
    static var fog: Color {
        let rgbFloat: CGFloat = 193 / 255
        return Color(UIColor(red: rgbFloat, green: rgbFloat, blue: rgbFloat, alpha: 1.0))
    }
    
    static var rock: Color {
        let rgbFloat: CGFloat = 139 / 255
        return Color(UIColor(red: rgbFloat, green: rgbFloat, blue: rgbFloat, alpha: 1.0))
    }
    
    static var charcoal: Color {
        let rgbFloat: CGFloat = 65 / 255
        return Color(UIColor(red: rgbFloat, green: rgbFloat, blue: rgbFloat, alpha: 1.0))
    }
    
    static var activeBlue: Color {
        Color(UIColor(red: 0 / 255, green: 125 / 255, blue: 179 / 255, alpha: 1.0))
    }
    
    static var systemBackground: Color {
        Color(UIColor.systemBackground)
    }
}
