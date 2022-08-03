//
//  HeroView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

struct HeroCell: View {
    let title: String
    var titleColor: Color = .black
    let imageName: String
    var alignment: HorizontalAlignment = .leading
    let buttonTitle: String
    let buttonStyle: HEBButton.ButtonStyle
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                HStack {
                    if alignment == .trailing {
                        Spacer()
                    }
                    
                    VStack(alignment: alignment, spacing: 8) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(titleColor)
                        
                        HEBButton(
                            title: buttonTitle,
                            style: .filled(.blue),
                            action: action
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 35)
                    
                    if alignment == .leading {
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct HeroView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                HeroCell(
                    title: "Seafood grilling",
                    imageName: "Seafood Grilling Image",
                    alignment: .trailing,
                    buttonTitle: "Shop Now",
                    buttonStyle: .filled(.blue),
                    action: {}
                )
                
                HeroCell(
                    title: "Gear Up For School",
                    titleColor: .white,
                    imageName: "School Image",
                    alignment: .center,
                    buttonTitle: "Shop Now",
                    buttonStyle: .filled(.white),
                    action: { print("Gear Up For School Tapped") }
                )
            }
            .padding()
        }
    }
}
