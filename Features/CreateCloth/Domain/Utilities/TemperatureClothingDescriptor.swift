//
//  TemperatureClothingDescriptor.swift
//  Clowy
//
//  Created by Егор Карпухин on 05.11.2024.
//

import SwiftUI

struct TemperatureClothingDescriptor {
    static let temperatureRanges: [(range: ClosedRange<CGFloat>, adjectives: [String])] = [
        
        (-50...(-35), [
            "arctic-grade",
            "extremely warm",
            "winter-proof",
        ]),
        
        (-35...(-25), [
            "super warm",
            "thick insulated",
            "heavily padded",
            "winter-ready",
            "cold-resistant"
        ]),
        
        (-25...(-15), [
            "warm",
            "well-insulated",
            "heat-retaining",
            "cozy warm",
            "thermal"
        ]),
        
        // Прохладно
        (-15...0, [
            "moderately warm",
            "insulated",
            "protective",
            "warming",
            "heat-keeping"
        ]),
        
        
        (0...10, [
            "light warm",
            "mild-weather",
            "transitional"
        ]),
        
        (10...20, [
            "comfortable",
            "breathable",
            "medium-weight",
            "balanced",
            "versatile"
        ]),
        
        (20...25, [
            "light",
            "airy",
            "cooling",
            "summer-ready",
            "breezy"
        ]),
        
        (25...35, [
            "lightweight",
            "thin",
            "heat-dissipating"
        ]),
        
        (35...50, [
            "ultra-light",
            "heat-resistant",
            "moisture-wicking",
            "sun-protective"
        ])
    ]
    
    static func getAdjective(for temperatureRange: ClosedRange<CGFloat>) -> String {
        let averageTemperature = (temperatureRange.upperBound + temperatureRange.lowerBound) / 2
        
        for (range, adjectives) in temperatureRanges {
            if range.contains(averageTemperature) {
                return adjectives.randomElement() ?? "comfortable"
            }
        }
        
        if averageTemperature < -50 {
            return "extreme-cold-protective"
        } else if averageTemperature > 50 {
            return "extreme-heat-protective"
        }
        
        return "comfortable"
    }
}
