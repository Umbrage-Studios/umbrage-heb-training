//
//  MainView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    let coordinator: MainCoordinator

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Rectangle()
                        .frame(height: 214)
                        .foregroundColor(.systemBackground)
                    
                    HeroCell(
                        title: "Seafood grilling",
                        imageName: "Seafood Grilling Image",
                        buttonTitle: "Shop Now",
                        buttonStyle: .filled(.blue),
                        action: {
                            print("Shop Now Tapped")
                        }
                    )
                    .padding(.horizontal, 15)
                    .padding(.top, 22)
                    
                    Text("Summer backyard party")
                        .font(.title2)
                        .fontWeight(.black)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            CategoryCell(
                                title: "Summer Salads",
                                imageName: "Summer Salads Image"
                            )

                            CategoryCell(
                                title: "Fresh cut favorites",
                                imageName: "Fresh Cut Image"
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    HeroCell(
                        title: "Gear Up For School",
                        titleColor: .white,
                        imageName: "School Image",
                        alignment: .center,
                        buttonTitle: "Shop Now",
                        buttonStyle: .filled(.white),
                        action: { print("Gear Up For School Tapped") }
                    )
                    .padding(.horizontal, 15)
                    .padding(.top, 22)
                    
                    Text("Everyday essentials")
                        .font(.title2)
                        .fontWeight(.black)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            CategoryCell(
                                title: "Stock up on household essentials",
                                imageName: "Household Image"
                            )
                            
                            CategoryCell(
                                title: "Stock up on snack essentials",
                                imageName: "Snacking Image"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            VStack {
                RoundedBottomHeaderView()
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .background(Color.dust)
                            .clipShape(Circle())
                        
                        Image(systemName: "cart.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                    }
                    .frame(width: 70, height: 70)
                    .padding(.bottom, 80)
                    .padding(.trailing)
                }
            }
        }
        .mask(LinearGradient(
            gradient: Gradient(colors: [.black, .black, .black, .black, .black, .black, .black, .black, .clear]),
            startPoint: .top,
            endPoint: .bottom)
        )
        .ignoresSafeArea(edges: [.top, .bottom])
    }
    
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainViewModel()
        let coordinator = MainCoordinator(viewModel: viewModel)

        coordinator.start()
    }
}



