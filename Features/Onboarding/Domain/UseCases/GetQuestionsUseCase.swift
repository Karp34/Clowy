//
//  GetQuestionsUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class GetQuestionsUseCase {
    private let repository: IOnboardingRepository

    init(repository: IOnboardingRepository) {
        self.repository = repository
    }

    func execute() async throws -> [OnboardingQuestion] {
        try await repository.getQuestions()
    }
}
