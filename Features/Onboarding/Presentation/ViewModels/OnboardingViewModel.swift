//
//  OnboardingViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {

    // MARK: - Published

    @Published var questions: [OnboardingQuestion] = OnboardingViewModel.defaultQuestions()
    @Published var chosenStyle: OnboardingStyleCircle = OnboardingStyleCircle(icon: "", style: "", size: 0, styleRawValue: "")
    @Published var chosenWeathers: [String] = []
    @Published var didRetryOnboarding = false
    @Published var username: String = ""

    // MARK: - Default questions

    static func defaultQuestions() -> [OnboardingQuestion] {
        OnboardingConstants.defaultQuestions
    }

    // MARK: - Navigation

    func hidePages() {
        switch questions[4].answer.first {
        case "Only skirts":
            setVisible([5: true, 6: true, 7: false, 8: false])
        case "Only dresses":
            setVisible([5: false, 6: false, 7: true, 8: true])
        case "I don't wear":
            setVisible([5: false, 6: false, 7: false, 8: false])
        default:
            setVisible([5: true, 6: true, 7: true, 8: true])
        }
    }

    private func setVisible(_ map: [Int: Bool]) {
        for (index, visible) in map {
            questions[index].isVisible = visible
            if !visible { questions[index].answer = [] }
        }
    }

    // MARK: - Build user from answers

    func buildUpdatedUser(from user: User) -> User {
        var updated = user
        updated.didOnboarding = true
        updated.preferedStyle = answer(for: 2) ?? "casual"
        updated.hatTemperature = answer(for: 3) ?? "0°C and below"
        updated.isTshirtUnder = answer(for: 4) != "No"
        updated.excludedClothes = buildExcludedClothes(from: answers(for: 5))
        updated.skirtWeather = answers(for: 6)
        updated.skirtPairings = answers(for: 7)
        updated.dressWeather = answers(for: 8)
        updated.dressPairings = answers(for: 9)
        updated.config = answer(for: 10) ?? "Normal"
        updated.username = username.isEmpty ? updated.username : username
        return updated
    }

    private func answer(for id: Int) -> String? {
        questions.first(where: { $0.id == id })?.answer.first
    }

    private func answers(for id: Int) -> [String] {
        questions.first(where: { $0.id == id })?.answer ?? []
    }

    private func buildExcludedClothes(from answers: [String]) -> [String] {
        var result: [String] = []
        if answers.contains("Only dresses") || answers.contains("I don't wear") { result.append("skirts") }
        if answers.contains("Only skirts") || answers.contains("I don't wear") { result.append("dresses") }
        return result
    }

    // MARK: - Reset

    func clearViewModel() {
        questions = OnboardingViewModel.defaultQuestions()
        chosenStyle = OnboardingStyleCircle(icon: "", style: "", size: 0, styleRawValue: "")
        chosenWeathers = []
        didRetryOnboarding = false
        username = ""
    }
}
