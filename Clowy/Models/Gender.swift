//
//  Gender.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.08.2022.
//

import SwiftUI

struct Gender {
    var icon: String
    var color: genderColor
}

enum genderColor: String {
    case male = "#5bcefa"
    case female = "#f5a9b8"
    case transgender = "#FFBF00"
}
