//
//  MainViewModel.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    let shouldShowLogin = CurrentValueSubject<Bool, Never>(false)
    let network: Network
    @Published var shouldShowSearch = false
    private var cancellables = Set<AnyCancellable>()
    
    init(network: Network = RequestManager.shared) {
        self.network = network

//        setupSubscriptions()
        requestKrogerAccess()
    }
    
//    private func setupSubscriptions() {
//        $shouldShowSearch
//            .sink { isShowing in
//                print("SEARCH IS SHOWING: \(isShowing)")
//            }
//            .store(in: &cancellables)
//    }
    
    private func requestKrogerAccess() {
        Task {
            let authToken: AuthToken? = try? await network.send(.krogerAuth)
            TokenManager.shared.token = authToken
            
            let response: ProductResponse = try await network.send(.productSearch(for: "apples"))
            print(response.products)
        }
    }
}
