//
//  CreateNewClothView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI

struct CreateNewClothView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    @StateObject private var viewModel = CreateNewClothViewModel.shared
    
    
    @State var showingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            WalkThroughPages()
            nextButton
                .opacity(viewModel.currentPage > 0 ? 1 : 0)
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
    
    private var navigationBar: some View {
        HStack {
            backButton
                .opacity(viewModel.currentPage > 0 ? 1 : 0)
            Spacer()
            Text("Add new cloth")
                .font(.custom("Montserrat-Bold", size: 14))
                .foregroundStyle(Color.black)
            Spacer()
            closeButton
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Want to quit?"),
                        message: Text("You almost finished"),
                        primaryButton:  .default(Text("Yes")) {
                            mainViewModel.showAddNewClothModel = false
                            viewModel.reset()
                            viewModel.currentPage = 0
                            print("Yes, skip onboarding")
                        },
                        secondaryButton:  .default(Text("No, continue")) {
                            print("No, continue")
                        }
                    )
                }
        }
        .frame(height: 60)
        .padding(.leading, 16)
        .padding(.trailing, 20)
    }
    
    private var backButton: some View {
        Button {
            withAnimation {
                if viewModel.currentPage > 0 {
                    if viewModel.isDefaultPhoto {
                        let index = viewModel.defaultPhotoFlow.firstIndex(where: {$0 == viewModel.currentPage})!
                        viewModel.currentPage = viewModel.defaultPhotoFlow[index-1]
                    } else {
                        let index = viewModel.notDefaultPhotoFlow.firstIndex(where: {$0 == viewModel.currentPage})!
                        viewModel.currentPage = viewModel.notDefaultPhotoFlow[index-1]
                    }
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 24, height: 24)
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }
        }
    }
    
    private var closeButton: some View {
        Button {
            showingAlert = true
        } label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 24, height: 24)
                Image(systemName: "xmark")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 9, height: 9)
                    .foregroundColor(.black)
            }
        }
    }

    private var nextButton: some View {
        Button {
            withAnimation {
                if viewModel.currentPage < 6 && viewModel.currentPage > 0{
                    if viewModel.isDefaultPhoto {
                        let index = viewModel.defaultPhotoFlow.firstIndex(where: {$0 == viewModel.currentPage})!
                        viewModel.currentPage = viewModel.defaultPhotoFlow[index+1]
                    } else {
                        let index = viewModel.notDefaultPhotoFlow.firstIndex(where: {$0 == viewModel.currentPage})!
                        viewModel.currentPage = viewModel.notDefaultPhotoFlow[index+1]
                    }
                } else {
                    // Сохранение и закрытие
                }
            }
        } label: {
            HStack {
                Spacer()
                Text(viewModel.currentPage == 6 ? "Save" : "Next")
                    .font(.custom("Montserrat-ExtraBold", size: 16))
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .frame(height:48)
        }
        .buttonStyle(DefaultColorButtonStyle(color: "#75A4FF", radius: 64))
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    func WalkThroughPages() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                CreateNewClothPage0(size: size, index: 0)
                CreateNewClothPage1(size: size, index: 1)
                CreateNewClothPage2(size: size, index: 2)
                CreateNewClothPage3(size: size, index: 3)
                CreateNewClothPage4(size: size, index: 4)
                CreateNewClothPage5(size: size, index: 5)
                CreateNewClothPage6(size: size, index: 6)
            }
        }
    }
    
    @ViewBuilder
    func CreateNewClothPage0(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            ChooseFlowView()
                .padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage1(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Hold, Drag and Drop photo below") {
            RemoveBackgroundView()
                .padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
        
    @ViewBuilder
    func CreateNewClothPage2(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Choose category") {
            SelectCategoryView()
                .padding(.leading, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
    
    @ViewBuilder
    func CreateNewClothPage3(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Select category type") {
            Text("3 - choose image")
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage4(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Choose cloth color") {
            Text("4 - choose color")
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage5(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Select temperature range") {
            Text("5 - choose temp")
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage6(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"New cloth preview") {
            Text("6 - final")
        }
            .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
    
}
