//
//  RoundedBottomHeaderView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

struct RoundedBottomHeaderView: View {
    let searchAction: () -> Void
    
    var body: some View {
        ZStack {
            Image("Blueberries")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 214)
                .contentShape(RoundedBottomHeaderShape())
                .clipShape(RoundedBottomHeaderShape())
                .frame(maxWidth: .infinity)
            
            // MARK: H-E-B Logo
            VStack {
                HStack {
                    Image("HEBLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .padding(.top, 34)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            
            // MARK: Search
            VStack {
                HStack {
                    Spacer()
                    
                    Button(
                        action: searchAction,
                        label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    )
                    .padding(.top, 40)
                }
                
                Spacer()
            }
            
            // MARK: Description
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                       Text("Baytown H-E-B")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Text("Available today \(Image(systemName: "chevron.down"))")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .padding(.bottom, 48)
                    
                    Spacer()
                }
            }
        }
        .frame(height: 214)
    }
}

struct RoundedBottomHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RoundedBottomHeaderView {}
        }
        .ignoresSafeArea(edges: [.top])
    }
}

struct RoundedBottomHeaderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY - 20
            )
        )
        path.addCurve(
            to: CGPoint(
                x: rect.midX,
                y: rect.maxY
            ),
            control1: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        )
        path.addCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY - 20
            ),
            control1: CGPoint(
                x: rect.midX,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )
        
        return path
    }
}
