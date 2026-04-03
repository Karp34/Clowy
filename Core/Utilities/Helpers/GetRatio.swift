//
//  GetRatio.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
//

import SwiftUI

class GetRatio {
    static func getRatio(type: ClothesType) -> AspectRatioTypes {
        switch type {
        case .accessories , .gloves, .headdresses, .scarves, .sneakers, .sunglasses, .socks, .umbrellas, .blank :
            return AspectRatioTypes.square
        case _ :
            return AspectRatioTypes.rectangle
        }
    }
}
