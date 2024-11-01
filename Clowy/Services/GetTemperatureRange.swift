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
    
    static func getTemperatureList() -> [Temperature] {
        [
            Temperature(id: 0, name: TemperatureType.superCold.rawValue, temp: [-30, -20]),
            Temperature(id: 1, name: TemperatureType.cold.rawValue, temp: [-20, -10]),
            Temperature(id: 2, name: TemperatureType.coldy.rawValue, temp: [-10, -5]),
            Temperature(id: 3, name: TemperatureType.cool.rawValue, temp: [-5, 5]),
            Temperature(id: 4, name: TemperatureType.regular.rawValue, temp: [5, 15]),
            Temperature(id: 5, name: TemperatureType.warm.rawValue, temp: [15, 25]),
            Temperature(id: 6, name: TemperatureType.hot.rawValue, temp: [25, 35])
        ]
    }
    
    static func decodeTemperature(listTemp: [String]) -> [Temperature] {
        var outputList = [Temperature]()
        let tempList = GetTemperatureRange.getTemperatureList()
        
        for item in listTemp {
            if let tempListItem = tempList.first(where: { $0.name == item }) {
                outputList.append(tempListItem)
            }
        }
        
        return outputList
    }
}
