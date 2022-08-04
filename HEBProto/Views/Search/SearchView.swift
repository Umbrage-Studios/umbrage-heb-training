//
//  SearchView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/3/22.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    let coordinator: SearchCoordinator
    
    @FocusState private var isSearching: Bool
    
    var body: some View {
        VStack {
            SearchBar(
                text: $viewModel.searchText,
                isSearching: _isSearching,
                trailingButtonAction: searchButtonAction
            )
            
            ScrollView(showsIndicators: false) {
                // Search results here
            }
            
            NavigationLink(
                isActive: $viewModel.shouldScan,
                destination: { coordinator.view(for: .scan) },
                label: { EmptyView() }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func searchButtonAction() {
        if isSearching {
            coordinator.send(.clearButtonTapped)
        } else {
            coordinator.send(.scanButtonTapped)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchViewModel()
        let coordinator = SearchCoordinator(viewModel: viewModel)
        
        coordinator.start()
    }
}
