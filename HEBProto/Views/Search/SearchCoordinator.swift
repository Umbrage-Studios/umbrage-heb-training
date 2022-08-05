//
//  SearchCoordinator.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/3/22.
//

import SwiftUI

final class SearchCoordinator {
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
}

extension SearchCoordinator {
    func start() -> some View {
        SearchView(viewModel: viewModel, coordinator: self)
    }
}

extension SearchCoordinator {
    enum Event {
        case clearButtonTapped
        case productDetailsTapped(for: Product)
        case scanButtonTapped
    }
    
    func send(_ event: Event) {
        switch event {
        case .clearButtonTapped:
            viewModel.searchText = ""
        case .productDetailsTapped(let product):
            viewModel.selectedProduct = product
        case .scanButtonTapped:
            viewModel.shouldScan = true
        }
    }
}

extension SearchCoordinator {
    enum Destination {
        case productDetails(for: Product)
        case scan
    }
    
    @ViewBuilder func view(for destination: Destination) -> some View {
        switch destination {
        case .productDetails(let product):
            let viewModel = ProductDetailsViewModel(product: product)
            let coordinator = ProductDetailsCoordinator(viewModel: viewModel)
            
            coordinator.start()
        case .scan:
            scanView
        }
    }
    
    private var scanView: ScanView {
        let scanViewModel = ScanViewModel()
        
        // Subscribe
        scanViewModel.scanResult
            .sink { [weak self] in self?.viewModel.barcode.send($0) }
            .store(in: &scanViewModel.cancellables)
        
        return ScanView(viewModel: scanViewModel)
    }
}
