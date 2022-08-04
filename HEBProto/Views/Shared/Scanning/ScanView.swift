//
//  ScanView.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import SwiftUI
import Combine

final class ScanViewModel {
    let scanResult = PassthroughSubject<String, Never>()
    var cancellables = Set<AnyCancellable>()
}

struct ScanView: UIViewControllerRepresentable {
    let viewModel: ScanViewModel
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, ScanResultReceiving {
        let parent: ScanView
        
        init(parent: ScanView) {
            self.parent = parent
        }
        
        func found(code: String) {
            parent.viewModel.scanResult.send(code)
        }
    }
}
