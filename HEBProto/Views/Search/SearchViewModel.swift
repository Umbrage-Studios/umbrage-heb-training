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
    private var cancellables = Set<AnyCancellable>()
    
    let barcode = PassthroughSubject<String, Never>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        barcode
            .sink { [weak self] code in
                self?.shouldScan = false
                self?.searchForProduct(with: code)
            }
            .store(in: &cancellables)
    }
    
    private func searchForProduct(with code: String) {
        // Network request to find the product
        
        // once the product is returned, show the sheet for product details
//        selectedProduct = product
    }
}
