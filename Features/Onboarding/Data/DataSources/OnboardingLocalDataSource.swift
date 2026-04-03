//
//  OnboardingLocalDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class OnboardingLocalDataSource {
    private let defaults = UserDefaults.standard
    
    private struct Keys {
        static func answersKey(for userId: String) -> String {
            return "onboarding_answers_\(userId)"
        }
        static let questionsKey = "onboarding_questions"
    }

    func getQuestions() -> [OnboardingQuestion] {
        // Questions are static, so returning empty array to signal use of defaults
        return []
    }

    func saveAnswers(_ input: OnboardingAnswersInput, userId: String) async throws {
        let answersDTO = OnboardingAnswersDTO(
            username: input.username,
            style: input.style,
            hatTemperature: input.hatTemperature,
            isTshirtUnder: input.isTshirtUnder,
            skirtPairings: input.skirtPairings,
            skirtWeather: input.skirtWeather,
            dressPairings: input.dressPairings,
            dressWeather: input.dressWeather,
            excludedClothes: input.excludedClothes
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(answersDTO)
        defaults.set(data, forKey: Keys.answersKey(for: userId))
    }

    func getAnswers(for userId: String) async throws -> OnboardingAnswersDTO? {
        guard let data = defaults.data(forKey: Keys.answersKey(for: userId)) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try decoder.decode(OnboardingAnswersDTO.self, from: data)
    }

    func clearAnswers(for userId: String) async throws {
        defaults.removeObject(forKey: Keys.answersKey(for: userId))
    }
}

// MARK: - DTO

struct OnboardingAnswersDTO: Codable {
    let username: String
    let style: String
    let hatTemperature: String
    let isTshirtUnder: Bool
    let skirtPairings: [String]
    let skirtWeather: [String]
    let dressPairings: [String]
    let dressWeather: [String]
    let excludedClothes: [String]
}
