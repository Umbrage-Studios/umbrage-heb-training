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
    
    var barcode: String?
}
