//
//  ProductDetailsViewModel.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import Foundation

final class ProductDetailsViewModel: ObservableObject {
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var imageURL: URL? {
        for image in product.images {
            if let rightSizedImage = image.images.first(where: { $0.size == .extraLarge }) {
                return URL(string: rightSizedImage.url)
            }
        }
        
        return nil
    }
    
    var title: String {
        product.description
    }
    
    var formattedPrice: String {
        "\(product.price) / each"
    }
    
    var formattedNationalPrice: String {
        guard
            let item = product.items.first(where: { $0.nationalPrice != nil }),
            let nationalPrice = item.nationalPrice
            else { return "" }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        let bestPrice = Double(nationalPrice.bestPrice) / 100
        guard let formattedPrice = formatter.string(from: bestPrice as NSNumber) else { return " " }
        
        return "\(formattedPrice) / each"
    }
}
