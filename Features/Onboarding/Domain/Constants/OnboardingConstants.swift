//
//  OnboardingConstants.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

struct OnboardingConstants {
    static let defaultQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(id: 1,  question: "Tell us more about \nyourself", answer: [], isVisible: true),
        OnboardingQuestion(id: 2,  question: "Which of the styles below\nsuits you best?", answer: [], isVisible: true),
        OnboardingQuestion(id: 3,  question: "At what temperature do you wear your winter hat?", answer: [], isVisible: true),
        OnboardingQuestion(id: 4,  question: "Do you wear T-Shirt under the Sweater?", answer: [], isVisible: true),
        OnboardingQuestion(id: 5,  question: "Do you wear skirts / dresses?", answer: [], isVisible: true),
        OnboardingQuestion(id: 6,  question: "Under what weather conditions do you wear a skirt?", answer: [], isVisible: true),
        OnboardingQuestion(id: 7,  question: "With what types of clothes do you prefer to wear a skirt?", answer: [], isVisible: true),
        OnboardingQuestion(id: 8,  question: "Under what weather conditions do you wear a dress?", answer: [], isVisible: true),
        OnboardingQuestion(id: 9,  question: "With what types of clothes do you prefer to wear a dress?", answer: [], isVisible: true),
        OnboardingQuestion(id: 10, question: "How would you describe your preference for dressing?", answer: [], isVisible: true)
    ]
}
