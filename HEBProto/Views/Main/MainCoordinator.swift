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

// MARK: - Navigator
