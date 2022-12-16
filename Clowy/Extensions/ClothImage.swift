//
//  ClothImage.swift
//  Clowy
//
//  Created by Егор Карпухин on 11.10.2022.
//

import SwiftUI

struct ClothImage: View {
    var imageName: Data?
    var isDeafult: Bool
    var color: String
    
    
    var body: some View {
        if imageName != nil {
            if isDeafult == true {
                Image(uiImage: UIImage(data: imageName!)!)
                    .resizable()
                    .colorMultiply(Color(hex: color))
            } else {
                Image(uiImage: UIImage(data: imageName!)!)
                    .resizable()
            }
        }
    }
}
