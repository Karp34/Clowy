//
//  OnboardingQuiz.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.03.2024.
//

import SwiftUI

class OnboardingQuizViewModel: ObservableObject {
    static var shared = OnboardingQuizViewModel()
    
    @Published var questions: [OnboardingQuestion] = [
        OnboardingQuestion(id: 1, question: "Tell us more about \nyourself", answer: []),
        OnboardingQuestion(id: 2, question: "Which of the styles below\nsuits you best?", answer: []),
        OnboardingQuestion(id: 3, question: "At what temperature do you wear your winter hat?", answer: []),
        OnboardingQuestion(id: 4, question: "Do you wear T-Shirt under the Sweater?", answer: []),
        OnboardingQuestion(id: 5, question: "Do you wear skirts / dresses?", answer: []),
        OnboardingQuestion(id: 6, question: "Under what weather conditions do you wear a skirt?", answer: []),
        OnboardingQuestion(id: 7, question: "With what types of clothes do you prefer to wear a skirt? ", answer: []),
        OnboardingQuestion(id: 8, question: "Under what weather conditions do you wear a dress?", answer: []),
        OnboardingQuestion(id: 9, question: "With what types of clothes do you prefer to wear a dress? ", answer: []),
        OnboardingQuestion(id: 10, question: "How would you describe your preference for dressing?", answer: [])
    ]
    
    
    @Published var chosenStyle: OnboardingStyleCircle = OnboardingStyleCircle(icon: "", style: "", size: 0)
    @Published var chosenWeathers: [String] = []
    @Published var user: User = User(id: "", username: "", userIcon: "", config: "Normal")
}

struct OnboardingQuiz: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    @StateObject var mainViewModel = MainScreenViewModel.shared
    @State var currentPage: Int = 1
    @State var username = ""
    @State var showingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            let totalPages: CGFloat = CGFloat(Float(viewModel.questions.count))
            
            VStack(alignment: .trailing, spacing: 16) {
                ProgressBarQuiz(totalPages: totalPages, currentPage: CGFloat(currentPage))
                    .frame(height: 8)
                
                Button {
                    showingAlert.toggle()
                } label: {
                    Text("Skip")
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundStyle(Color.primaryBlueBrand)
                }
                .opacity(currentPage > 1 ? 1 : 0)
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Want to skip the onboarding?"),
                        message: Text("It is very important for the correct selection of outfits"),
                        primaryButton:  .default(Text("Yes")) {
                            mainViewModel.updateUser(username: viewModel.user.username, userIcon: viewModel.user.userIcon, config: viewModel.user.config)
                            print("Yes, skip onboarding")
                        },
                        secondaryButton:  .default(Text("No, continue")) {
                            print("No, continue")
                        }
                    )
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
                        withAnimation(.easeInOut(duration: 1.5)) {
                            if currentPage > 1 {
                                currentPage -= 1
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 64)
                                .foregroundStyle(Color(hex: "#DDE9FF"))
                            
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
                            currentPage += 1
                        } else if currentPage == viewModel.questions.count {
                            mainViewModel.updateUser(username: viewModel.user.username, userIcon: viewModel.user.userIcon, config: viewModel.user.config)
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 64)
                            .foregroundStyle(Color.secondaryBlueBrand)
                        
                        Text("Next")
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundStyle(Color.white)
                    }
                    .frame(height: 48)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.primaryBackground)
    }
    
    @ViewBuilder
    func WalkThroughPages() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                OnboardingPage1(size: size, index: 1, currentPage: currentPage, username: username)
                OnboardingPage2(size: size, index: 2, currentPage: currentPage)
                OnboardingPage3(size: size, index: 3, currentPage: currentPage)
                OnboardingPage4(size: size, index: 4, currentPage: currentPage)
                OnboardingPage5(size: size, index: 5, currentPage: currentPage)
                OnboardingPage6(size: size, index: 6, currentPage: currentPage)
                OnboardingPage7(size: size, index: 7, currentPage: currentPage)
                OnboardingPage8(size: size, index: 8, currentPage: currentPage)
                OnboardingPage9(size: size, index: 9, currentPage: currentPage)
                OnboardingPage10(size: size, index: 10, currentPage: currentPage)
            }
        }
    }
    
    
    @ViewBuilder
    func OnboardingPage1(size: CGSize, index: Int, currentPage: Int, username: String) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            VStack(spacing: 40) {
                CustomSliderView()
                    .frame(height: 138)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1), value: currentPage)
                
                TextField("", text: $username)
                    .textFieldStyle(CustomFieldStyle3(size: 16))
                    .placeholder("Your name", when: username.isEmpty)
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
                    .onChange(of: username) {
                        viewModel.user.username = username
                        print(viewModel.user)
                    }
            }
            .padding(.top, 104)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage2(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            StyleCircles(index: index, currentPage: currentPage)
                .padding(.top, 63)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage3(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            WideSliderView(questionIndex: index)
                .padding(.top, 66)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.2 : 0), value: currentPage)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage4(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(options: ["Yes", "No"], withCheckpoints: false, currentPage: currentPage, index: index)
                .padding(.top, 66)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage5(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(options: ["Yes", "Only skirts", "Only dresses", "I don’t wear"], withCheckpoints: false, currentPage: currentPage, index: index)
                .padding(.top, 66)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage6(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            RandomCirclesView(index: index, currentPage: currentPage)
                .padding(.top, 28)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage7(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(options: ["Jacket", "Blazer", "Cardigan, Sweater, Tutrtleneck", "Shirt", "T-Shir, Top", "Leggins",  "With nothing"], withCheckpoints: true, currentPage: currentPage, index: index)
                .padding(.top, 40)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage8(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            RandomCirclesView(index: index, currentPage: currentPage)
                .padding(.top, 28)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage9(size: CGSize, index: Int, currentPage: Int) -> some View {
        OnboardingPage(size: size, index: index, currentPage: currentPage) {
            QuizOptionButton(options: ["Jacket", "Blazer", "Cardigan, Sweater, Tutrtleneck", "Shirt", "T-Shir, Top", "Leggins",  "With nothing"], withCheckpoints: true, currentPage: currentPage, index: index)
                .padding(.top, 40)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func OnboardingPage10(size: CGSize, index: Int, currentPage: Int) -> some View {
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






