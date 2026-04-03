//
//  OnboardingRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class OnboardingRepositoryImpl: IOnboardingRepository {
    private let localDataSource: OnboardingLocalDataSource
    private let userId: String

    init(localDataSource: OnboardingLocalDataSource = OnboardingLocalDataSource(), userId: String) {
        self.localDataSource = localDataSource
        self.userId = userId
    }

    func getQuestions() async throws -> [OnboardingQuestion] {
        let cachedQuestions = localDataSource.getQuestions()
        if !cachedQuestions.isEmpty {
            return cachedQuestions
        }
        
        // Return default questions if cache is empty
        return OnboardingConstants.defaultQuestions
    }

    func saveAnswers(_ input: OnboardingAnswersInput) async throws {
        try await localDataSource.saveAnswers(input, userId: userId)
    }
}
