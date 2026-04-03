//
//  CreateNewClothView.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

struct CreateNewClothView: View {
    var isEditingCloth = false
    var cloth: Cloth? = nil
    @Binding var isShowingSheet: Bool
    @StateObject private var viewModel = CreateClothViewModel()

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            WalkThroughPages()
            nextButton
                .opacity(viewModel.currentPage > 0 ? 1 : 0)
        }
        .environmentObject(viewModel)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .onAppear {
            guard let cloth, isEditingCloth else { return }
            viewModel.clothId = cloth.id
            viewModel.name = cloth.name
            viewModel.type = cloth.type
            viewModel.color = cloth.color
            viewModel.image = cloth.image
            viewModel.isDefault = cloth.isDefault
            viewModel.temp = GetTemperatureRange.decodeTemperature(listTemp: cloth.temperature)
        }
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack {
            backButton.opacity(viewModel.currentPage > 0 ? 1 : 0)
            Spacer()
            Text("Add new cloth")
                .font(.custom("Montserrat-Bold", size: 14))
                .foregroundStyle(Color.black)
            Spacer()
            closeButton
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
                        let index = viewModel.defaultPhotoFlow.firstIndex(where: { $0 == viewModel.currentPage })!
                        viewModel.currentPage = viewModel.defaultPhotoFlow[index - 1]
                    } else {
                        let index = viewModel.notDefaultPhotoFlow.firstIndex(where: { $0 == viewModel.currentPage })!
                        viewModel.currentPage = viewModel.notDefaultPhotoFlow[index - 1]
                    }
                }
            }
        } label: {
            ZStack {
                Rectangle().foregroundStyle(.clear).frame(width: 24, height: 24)
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }
        }
    }

    private var closeButton: some View {
        Button { isShowingSheet = false } label: {
            ZStack {
                Rectangle().foregroundStyle(.clear).frame(width: 24, height: 24)
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
                if viewModel.currentPage < 6 && viewModel.currentPage > 0 {
                    if viewModel.isDefaultPhoto {
                        let index = viewModel.defaultPhotoFlow.firstIndex(where: { $0 == viewModel.currentPage })!
                        viewModel.currentPage = viewModel.defaultPhotoFlow[index + 1]
                    } else {
                        let index = viewModel.notDefaultPhotoFlow.firstIndex(where: { $0 == viewModel.currentPage })!
                        viewModel.currentPage = viewModel.notDefaultPhotoFlow[index + 1]
                    }
                } else {
                    Task {
                        do {
                            if isEditingCloth {
                                try await viewModel.updateCloth()
                            } else {
                                try await viewModel.saveCloth()
                            }
                            isShowingSheet = false
                        } catch {
                            AppLogger.log("Save cloth error: \(error)")
                        }
                    }
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
            .frame(height: 48)
        }
        .buttonStyle(DefaultColorButtonStyle(color: Color.secondaryBlueBrand, radius: 64))
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }

    // MARK: - Pages

    @ViewBuilder
    func WalkThroughPages() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                page0(size: size, index: 0)
                page1(size: size, index: 1)
                page2(size: size, index: 2)
                page3(size: size, index: 3)
                page4(size: size, index: 4)
                page5(size: size, index: 5)
                page6(size: size, index: 6)
            }
        }
    }

    @ViewBuilder
    private func page0(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Upload cloth photo") {
            ChooseFlowView().padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page1(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Preparing the photo") {
            RemoveBackgroundView().padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page2(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Choose category") {
            SelectCategoryView().padding(.leading, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page3(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Select category type") {
            SelectCategoryPhoto().padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page4(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Choose cloth color") {
            SelectColor().padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page5(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "Select temperature range") {
            ChooseTemperatureRangeView()
                .padding(.horizontal, 24)
                .padding(.top, 36)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }

    @ViewBuilder
    private func page6(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title: "New cloth preview") {
            PreviewNewClothView().padding(.horizontal, 24)
        }
        .offset(x: -size.width * CGFloat(viewModel.currentPage - index))
    }
}
