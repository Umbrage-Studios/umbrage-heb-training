//
//  MainCoordinator.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

final class MainCoordinator {
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Coordinator

extension MainCoordinator {
    /// This provides the initial view for the coordinator
    func start() -> some View {
        MainView(viewModel: viewModel, coordinator: self)
    }
}

// MARK: - Event Handler

extension MainCoordinator {
    enum Event {
        case searchButtonTapped
    }
    
    func send(_ event: Event) {
        switch event {
        case .searchButtonTapped:
            viewModel.shouldShowSearch.toggle()
        }
    }
}

// MARK: - Navigator

extension MainCoordinator {
    enum Destination {
        case search
    }
    
    @ViewBuilder func view(for destination: Destination) -> some View {
        switch destination {
        case .search:
            let viewModel = SearchViewModel()
            let coordinator = SearchCoordinator(viewModel: viewModel)
            
            coordinator.start()
        }
    }
}
