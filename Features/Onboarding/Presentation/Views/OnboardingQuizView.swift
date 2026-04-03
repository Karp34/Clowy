//
//  OnboardingQuiz.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.03.2024.
//

//доделать закрытие онбординга

import SwiftUI

struct OnboardingQuiz: View {
    @StateObject var viewModel = OnboardingViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @State var currentPage: Int = 1
    @State var showingAlert = false

    var body: some View {
        VStack(spacing: 0) {
            let totalPages = CGFloat(viewModel.questions.count)

            VStack(alignment: .trailing, spacing: 16) {
                ProgressBarQuiz(totalPages: totalPages, currentPage: CGFloat(currentPage))
                    .frame(height: 8)

                if !viewModel.didRetryOnboarding {
                    Button { showingAlert.toggle() } label: {
                        Text("Skip")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundStyle(Color.primaryBlueBrand)
                    }
                    .opacity(currentPage > 1 ? 1 : 0)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Want to skip the onboarding?"),
                            message: Text("It is very important for the correct selection of outfits"),
                            primaryButton: .default(Text("Yes")) {
                                saveAndFinish()
                            },
                            secondaryButton: .default(Text("No, continue"))
                        )
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)

            WalkThroughPages()
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 16) {
                if currentPage > 1 {
                    Button {
                        withAnimation(.easeInOut(duration: 1.5)) { goBack() }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 64).foregroundStyle(Color.notChosenCircle)
                            Text("Back")
                                .font(.custom("Montserrat-ExtraBold", size: 16))
                                .foregroundStyle(Color.secondaryBlueBrand)
                        }
                        .frame(height: 48)
                    }
                }

                Button {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        if currentPage < viewModel.questions.count {
                            goForward()
                        } else {
                            saveAndFinish()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(currentPage == viewModel.questions.count ? "Finish" : "Next")
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .frame(height: 48)
                }
                .buttonStyle(DefaultColorButtonStyle(color: Color.secondaryBlueBrand, radius: 64))
                .disabled(viewModel.questions[currentPage - 1].answer.isEmpty)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .environmentObject(viewModel)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.primaryBackground)
    }

    // MARK: - Navigation

    private func goForward() {
        let index = currentPage - 1
        var counter = 1
        while index + counter < viewModel.questions.count &&
              !viewModel.questions[index + counter].isVisible {
            counter += 1
        }
        if index + counter < viewModel.questions.count {
            currentPage += counter
        }
    }

    private func goBack() {
        guard currentPage > 1 else { return }
        let index = currentPage - 1
        var counter = 1
        while index - counter >= 0 && !viewModel.questions[index - counter].isVisible {
            counter += 1
        }
        if index - counter >= 0 {
            currentPage -= counter
        }
    }

    private func saveAndFinish() {
        profileViewModel.user = viewModel.buildUpdatedUser(from: profileViewModel.user)
        Task {
            await profileViewModel.updateUser()
            viewModel.clearViewModel()
        }
    }

    // MARK: - Pages

    @ViewBuilder
    func WalkThroughPages() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                page1(size: size, index: 1)
                page2(size: size, index: 2)
                page3(size: size, index: 3)
                page4(size: size, index: 4)
                page5(size: size, index: 5)
                page6(size: size, index: 6)
                page7(size: size, index: 7)
                page8(size: size, index: 8)
                page9(size: size, index: 9)
                page10(size: size, index: 10)
            }
        }
    }

    @ViewBuilder
    private func page1(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            VStack(spacing: 40) {
                CustomSliderView()
                    .frame(height: 138)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1), value: currentPage)

                TextField("", text: $viewModel.username)
                    .textFieldStyle(CustomFieldStyle3(size: 16))
                    .placeholder("Your name", when: viewModel.username.isEmpty)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(Color.primaryBlueBrand)
                            .foregroundColor(.white)
                            .frame(height: 56)
                    )
                    .frame(height: 56)
                    .padding(.horizontal, 24)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0 : 0.2), value: currentPage)
                    .onAppear {
                        if !profileViewModel.user.username.isEmpty {
                            viewModel.username = profileViewModel.user.username
                            viewModel.questions[0].answer = [viewModel.username]
                        }
                    }
                    .onChange(of: viewModel.username) {
                        viewModel.questions[0].answer = [viewModel.username]
                    }
            }
            .padding(.top, 104)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page2(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            StyleCircles(index: index, currentPage: currentPage).padding(.top, 63)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page3(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            WideSliderView(questionIndex: index)
                .padding(.top, 66)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.2 : 0), value: currentPage)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page4(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(options: ["Yes", "No"], withCheckpoints: false, currentPage: currentPage, index: index)
                .padding(.top, 66)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page5(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(
                options: ["Yes", "Only skirts", "Only dresses", "I don't wear"],
                withCheckpoints: false,
                currentPage: currentPage,
                index: index
            )
            .padding(.top, 66)
            .onChange(of: viewModel.questions[4].answer) { viewModel.hidePages() }
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page6(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            RandomCirclesView(index: index, currentPage: currentPage).padding(.top, 28)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page7(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(
                options: ["Jacket", "Blazer, Suit Jacket", "Cardigan, Sweater, Tutrtleneck", "Shirt", "T-Shirt, Top", "Leggins"],
                withCheckpoints: true,
                currentPage: currentPage,
                index: index
            )
            .padding(.top, 40)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page8(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            RandomCirclesView(index: index, currentPage: currentPage).padding(.top, 28)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page9(size: CGSize, index: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(
                options: ["Jacket", "Blazer, Suit Jacket", "Cardigan, Sweater, Tutrtleneck", "Shirt", "T-Shirt, Top", "Leggins", "With nothing"],
                withCheckpoints: true,
                currentPage: currentPage,
                index: index
            )
            .padding(.top, 40)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }

    @ViewBuilder
    private func page10(size: CGSize, index: Int) -> some View {
        let options = [
            ["Warmer", "I prefer dressing for warmth,\n cozy and snug"],
            ["Normal", "I usually dress in a comfortable and\n moderate style"],
            ["Cooler", "I lean towards cooler attire, keeping\n things crisp and fresh."]
        ]
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButtonWithSubtitle(options: options, currentPage: currentPage, index: index)
                .padding(.top, 40)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
}
