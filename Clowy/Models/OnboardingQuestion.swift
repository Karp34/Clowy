//
//  OnboardingQuestion.swift
//  Clowy
//
//  Created by Егор Карпухин on 18.03.2024.
//

import Foundation

struct OnboardingQuestion: Hashable {
    var id: Int
    var question: String
    var answer: [String]
    var isVisible: Bool
}
