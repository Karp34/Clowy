//
//  GetTemperatureRange.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
//

import SwiftUI

class GetTemperatureRange {
    static func getTemperatureRange(type: TemperatureType) -> String {
        switch type {
        case .superCold :
            return "from -30 to -20 degrees"
        case .cold :
            return "from -20 to -10 degrees"
        case .coldy :
            return "from -10 to 0 degrees"
        case .regular:
            return "from 0 to 10 degrees"
        case .warm:
            return "from 10 to 20 degrees"
        case .hot:
            return "from 20 to 30 degrees"
        }
    }
}
