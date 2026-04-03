//
//  SaveOnboardingAnswersUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class SaveOnboardingAnswersUseCase {
    private let repository: IOnboardingRepository

    init(repository: IOnboardingRepository) {
        self.repository = repository
    }

    func execute(_ input: OnboardingAnswersInput) async throws {
        try await repository.saveAnswers(input)
    }
}

struct OnboardingAnswersInput {
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
