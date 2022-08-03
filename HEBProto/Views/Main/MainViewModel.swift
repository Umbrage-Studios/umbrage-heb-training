//
//  MainViewModel.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    let title: String
    let shouldShowLogin = CurrentValueSubject<Bool, Never>(false)
    
    init(title: String) {
        self.title = title
        
        setupSubscriptions()
        requestKrogerAccess()
    }
    
    private func setupSubscriptions() {
        
    }
    
    private func requestKrogerAccess() {
        Task {
            let authToken: AuthToken? = try? await RequestManager.shared.send(.krogerAuth)
            TokenManager.shared.token = authToken
        }
    }
}
