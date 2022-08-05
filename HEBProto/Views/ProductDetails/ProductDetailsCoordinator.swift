//
//  ProductDetailsCoordinator.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import SwiftUI

final class ProductDetailsCoordinator {
    let viewModel: ProductDetailsViewModel
    
    init(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
    }
}

extension ProductDetailsCoordinator {
    func start() -> some View {
        ProductDetailsView(viewModel: viewModel, coordinator: self)
    }
}
