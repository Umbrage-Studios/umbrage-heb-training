//
//  HEBProtoApp.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

@main
struct HEBProtoApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = MainViewModel()
            let coordinator = MainCoordinator(viewModel: viewModel)
            
            NavigationView {
                coordinator.start()
            }
        }
    }
}
