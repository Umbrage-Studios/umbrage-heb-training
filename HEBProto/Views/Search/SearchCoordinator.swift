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
        case scanButtonTapped
    }
    
    func send(_ event: Event) {
        switch event {
        case .clearButtonTapped:
            viewModel.searchText = ""
        case .scanButtonTapped:
            viewModel.shouldScan = true
        }
    }
}

extension SearchCoordinator {
    enum Destination {
        case scan
    }
    
    @ViewBuilder func view(for destination: Destination) -> some View {
        switch destination {
        case .scan:
            scanView
        }
    }
    
    private var scanView: ScanView {
        let scanViewModel = ScanViewModel()
        
        // Subscribe
        scanViewModel.scanResult
            .sink { [weak self] in self?.viewModel.barcode = $0 }
            .store(in: &scanViewModel.cancellables)
        
        return ScanView(viewModel: scanViewModel)
    }
}
