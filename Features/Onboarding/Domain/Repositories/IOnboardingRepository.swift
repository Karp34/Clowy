//
//  IOnboardingRepository.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

protocol IOnboardingRepository {
    func getQuestions() async throws -> [OnboardingQuestion]
    func saveAnswers(_ input: OnboardingAnswersInput) async throws
}
