//
//  FittingOutfit.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import Foundation

struct FittingOutfit: Identifiable, Equatable {
    var id: Int
    var style: OutfitStyle
    var outfit: [Cloth]
    var isGenerated: Bool
}

struct FittingOutfitsResponse: Identifiable {
    var id: Int
    var outfits: [FittingOutfit]
    var code: Int
    var error: String
}

struct PercentFittingOutfit {
    var style: OutfitStyle
    var outfit: [Cloth]
    var percent: Double
    var absentTypes: [ClothesPref]?
}
