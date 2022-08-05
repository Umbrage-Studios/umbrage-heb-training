//
//  ProductDetailsView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import SwiftUI

struct ProductDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductDetailsViewModel
    let coordinator: ProductDetailsCoordinator
    
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: { dismiss() },
                    label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 26)
                            .foregroundColor(.charcoal)
                            .padding()
                    }
                )
                
                Spacer()
                
                // This is where the share icon would go
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    AsyncImage(
                        url: viewModel.imageURL,
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal, 65)
                            
                        },
                        placeholder: {
                            VStack {
                                ProgressView()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 65)
                        }
                    )
                    .padding(.vertical, 30)
                    
                    VStack(spacing: 20) {
                        Text(viewModel.title)
                        
                        Text(viewModel.formattedPrice)
                        
                        Text(viewModel.formattedNationalPrice)
                    }
                }
            }
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProductDetailsViewModel(product: Product.example)
        let coordinator = ProductDetailsCoordinator(viewModel: viewModel)
        
        coordinator.start()
    }
}
