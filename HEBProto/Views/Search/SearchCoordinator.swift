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
        case productDetails(Product)
        case scanButtonTapped
    }
    
    func send(_ event: Event) {
        switch event {
        case .clearButtonTapped:
            viewModel.searchText = ""
        case .productDetails(let product):
            viewModel.selectedProduct = product
        case .scanButtonTapped:
            viewModel.shouldScan = true
        }
    }
}

extension SearchCoordinator {
    enum Destination {
        case productDetails(Product)
        case scan
    }
    
    @ViewBuilder func view(for destination: Destination) -> some View {
        switch destination {
        case .productDetails(let product):
            Text("SHOWING \(product.description)")
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
