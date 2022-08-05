//
//  SearchViewModel.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/3/22.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var shouldScan = false
    @Published var selectedProduct: Product?
    @Published var products = [Product]()
    private var cancellables = Set<AnyCancellable>()
    private let network: Network
    
    let barcode = PassthroughSubject<String, Never>()
    
    init(network: Network = RequestManager.shared) {
        self.network = network

        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        barcode
            .sink { [weak self] code in
                self?.shouldScan = false
                self?.searchForProduct(with: code)
            }
            .store(in: &cancellables)
        
        $searchText
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] in self?.searchForProducts(with: $0) }
            .store(in: &cancellables)
        
        $searchText
            .filter { $0.isEmpty }
            .sink { [weak self] _ in self?.products = [] }
            .store(in: &cancellables)
    }
    
    private func searchForProducts(with term: String) {
        Task {
            let response: ProductsResponse = try await network.send(.productSearch(for: term))
            
            await MainActor.run {
                products = response.products
            }
        }
    }
    
    private func searchForProduct(with code: String) {
        Task {
            let response: ProductResponse = try await network.send(.product(code))
            
            await MainActor.run {
                selectedProduct = response.product
            }
        }
    }
}
