//
//  HEBButton.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

struct HEBButton: View {
    enum ButtonStyle {
        case plain
        case filled(Color)
        case outlined(Color)
    }

    let title: String
    var style: ButtonStyle
    var action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .foregroundColor(textColor)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(backgroundColor)
                    .overlay(
                        Capsule()
                            .stroke(outlineColor, lineWidth: 1)
                    )
                    .clipShape(
                        Capsule()
                    )
            }
        )
    }
    
    private var textColor: Color {
        switch style {
        case .filled(let color):
            return color == .white ? .black : .white
        case .outlined(let color):
            return color
        default:
            return .black
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .filled(let color):
            return color
        default:
            return .clear
        }
    }
    
    private var outlineColor: Color {
        switch style {
        case .outlined(let color):
            return color
        default:
            return .clear
        }
    }
}

struct HEBButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HEBButton(title: "Shop Now", style: .plain, action: {})
            
            HEBButton(title: "Filled Background", style: .filled(.red)) {}
            
            HEBButton(title: "Black Filled Button", style: .filled(.black), action: {}
            )
            
            HEBButton(title: "Outlined Button", style: .outlined(.green), action: {})
        }
    }
}
