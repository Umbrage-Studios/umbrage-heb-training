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
    private let columns = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    @FocusState private var isSearching: Bool
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                SearchBar(
                    text: $viewModel.searchText,
                    isSearching: _isSearching,
                    trailingButtonAction: searchButtonAction
                )
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.products) { product in
                            ProductCell(product: product, proxy: reader)
                                .onTapGesture {
                                    coordinator.send(.productDetailsTapped(for: product))
                                }
                        }
                    }
                }
                
                NavigationLink(
                    isActive: $viewModel.shouldScan,
                    destination: { coordinator.view(for: .scan) },
                    label: { EmptyView() }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.selectedProduct) {
            coordinator.view(for: .productDetails(for: $0))
        }
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
