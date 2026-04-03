//
//  GenerateClothNameUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import CoreGraphics
import UIKit

final class GenerateClothNameUseCase {
    func execute(type: ClothesType, color: String, temperatureSelection: ClosedRange<CGFloat>) -> String {
        if !color.isEmpty && type != .blank {
            return getColorName(from: color).capitalized + " " + type.rawValue
        }
        return TemperatureClothingDescriptor
            .getAdjective(for: temperatureSelection).capitalized + " " + type.rawValue
    }

    private func getColorName(from hex: String) -> String {
        let basicColors: [(name: String, r: Int, g: Int, b: Int)] = [
            ("red", 255, 0, 0), ("green", 0, 255, 0), ("blue", 0, 0, 255),
            ("yellow", 255, 255, 0), ("purple", 128, 0, 128), ("orange", 255, 165, 0),
            ("black", 0, 0, 0), ("white", 255, 255, 255), ("gray", 128, 128, 128),
            ("pink", 255, 192, 203), ("brown", 165, 42, 42), ("light blue", 0, 255, 255)
        ]

        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Int((rgb >> 16) & 0xFF)
        let g = Int((rgb >> 8) & 0xFF)
        let b = Int(rgb & 0xFF)

        return basicColors.min(by: {
            colorDistance($0.r, $0.g, $0.b, r, g, b) < colorDistance($1.r, $1.g, $1.b, r, g, b)
        })?.name ?? "unknown"
    }

    private func colorDistance(_ r1: Int, _ g1: Int, _ b1: Int, _ r2: Int, _ g2: Int, _ b2: Int) -> Double {
        let rMean = Double(r1 + r2) / 2
        let r = Double(r1 - r2)
        let g = Double(g1 - g2)
        let b = Double(b1 - b2)
        return sqrt((2 + rMean/256) * pow(r, 2) + 4 * pow(g, 2) + (2 + (255-rMean)/256) * pow(b, 2))
    }
}
