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
            print("SCAN BUTTON TAPPED!")
        }
    }
}
