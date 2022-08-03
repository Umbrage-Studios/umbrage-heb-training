//
//  CategoryCell.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import SwiftUI

struct CategoryCell: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 220)
            
            Text(title)
                .font(.headline)
                .fontWeight(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 220)
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(title: "Summer Salads", imageName: "Summer Salads Image")
    }
}
