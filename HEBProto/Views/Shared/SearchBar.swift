//
//  SearchBar.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState var isSearching: Bool
    let trailingButtonAction: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Divider()
                    .foregroundColor(undelineColor)
                    .frame(height: isSearching ? 2 : 1)
                    .padding(.bottom, isSearching ? 0 : 1)
                    .padding(.horizontal)
            }
            .frame(height: 45)
            
            TextField(
                text: $text,
                prompt: Text("Search").foregroundColor(.rock),
                label: { EmptyView() }
            )
            .focused($isSearching)
            .padding(.vertical)
            .padding(.horizontal, 56)
            .onTapGesture { isSearching = true }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26)
                    .foregroundColor(iconColor)
                
                Spacer()
                
                Button(
                    action: {
                        trailingButtonAction()
                        isSearching = false
                    },
                    label: {
                        Image(systemName: trailingButtonIconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(iconColor)
                            .padding()
                    }
                )
            }
            .padding([.leading])
        }
    }
    
    private var trailingButtonIconName: String {
        isSearching ? "xmark.circle" : "barcode.viewfinder"
    }
    
    private var iconColor: Color {
        isSearching ? .activeBlue : .charcoal
    }
    
    private var undelineColor: Color {
        isSearching ? .activeBlue : .fog
    }
}


struct SearchBar_Previews: PreviewProvider {
    @FocusState static var isFocused: Bool
    static var previews: some View {
        SearchBar(
            text: .constant(""),
            isSearching: _isFocused,
            trailingButtonAction: {}
        )
    }
}
