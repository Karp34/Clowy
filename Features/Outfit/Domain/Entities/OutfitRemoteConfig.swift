//
//  OutfitRemoteConfig.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import Foundation

// Groups all Remote Config outfit configs together so they can be passed cleanly.
struct OutfitRemoteConfig {
    let superCold: OutfitConfig
    let cold: OutfitConfig
    let coldy: OutfitConfig
    let cool: OutfitConfig
    let regular: OutfitConfig
    let warm: OutfitConfig
    let hot: OutfitConfig
}
