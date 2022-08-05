//
//  ProductCell.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/5/22.
//

import SwiftUI

struct ProductCell: View {
    let product: Product
    let proxy: GeometryProxy

    var body: some View {
        VStack {
            AsyncImage(
                url: product.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 110, alignment: .center)
                },
                placeholder: {
                    VStack {
                        ProgressView()
                    }
                    .frame(width: 110, height: 110, alignment: .center)
                }
            )
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("\(product.price) / each")
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.charcoal)
                
                Text(product.description)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.charcoal)
                    .multilineTextAlignment(.leading)
                
                Text(product.locationDescription)
                    .font(.subheadline)
                    .foregroundColor(.rock)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: proxy.size.width * 0.4)
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { reader in
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))], spacing: 20) {
                ProductCell(product: Product.example, proxy: reader)
                ProductCell(product: Product.example, proxy: reader)
                ProductCell(product: Product.example, proxy: reader)
                ProductCell(product: Product.example, proxy: reader)
            }
        }
        
    }
}
