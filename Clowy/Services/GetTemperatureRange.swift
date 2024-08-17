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
            return "from -30° to -20° degrees"
        case .cold :
            return "from -20° to -10° degrees"
        case .coldy :
            return "from -10° to -5° degrees"
        case .cool:
            return "from -5° to 5° degrees"
        case .regular:
            return "from 5° to 15° degrees"
        case .warm:
            return "from 15° to 25° degrees"
        case .hot:
            return "from 25° to 30° degrees"
        }
    }
}
