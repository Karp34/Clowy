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
    @State var currentPage: Int = 0
    @State var isDefaultPhoto = false
    let defaultPhotoFlow = [0,1,2,6,7]
    let notDefaultPhotoFlow = [0,3,4,5,6,7]
    
    @State var showingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            WalkThroughPages()
            nextButton
                .opacity(currentPage > 0 ? 1 : 0)
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
    
    private var navigationBar: some View {
        HStack {
            backButton
                .opacity(currentPage > 0 ? 1 : 0)
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
                if currentPage > 0 {
                    if isDefaultPhoto {
                        let index = defaultPhotoFlow.firstIndex(where: {$0 == currentPage})!
                        currentPage = defaultPhotoFlow[index-1]
                        print("index", index)
                        print("currentPage", currentPage)
                    } else {
                        let index = notDefaultPhotoFlow.firstIndex(where: {$0 == currentPage})!
                        currentPage = notDefaultPhotoFlow[index-1]
                        print("index", index)
                        print("currentPage", currentPage)
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
                if currentPage < 7 && currentPage > 0{
                    if isDefaultPhoto {
                        let index = defaultPhotoFlow.firstIndex(where: {$0 == currentPage})!
                        currentPage = defaultPhotoFlow[index+1]
                        print("index", index)
                        print("currentPage", currentPage)
                    } else {
                        let index = notDefaultPhotoFlow.firstIndex(where: {$0 == currentPage})!
                        currentPage = notDefaultPhotoFlow[index+1]
                        print("index", index)
                        print("currentPage", currentPage)
                    }
                } else {
                    // Сохранение и закрытие
                }
            }
        } label: {
            HStack {
                Spacer()
                Text(currentPage == 7 ? "Save" : "Next")
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
                CreateNewClothPage7(size: size, index: 7)
            }
        }
    }
    
    @ViewBuilder
    func CreateNewClothPage0(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white)
                        .border(Color(hex:"F1F1F1"), width: 1)
                    Text("Galary")
                }
                .onTapGesture {
                    withAnimation {
                        currentPage = 1
                        isDefaultPhoto = true
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white)
                        .border(Color(hex:"F1F1F1"), width: 1)
                    Text("Galary")
                }
                .onTapGesture {
                    withAnimation {
                        currentPage = 3
                        isDefaultPhoto = false
                    }
                }
            }
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage1(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("1 - choose photo")
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.red)
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
        
    @ViewBuilder
    func CreateNewClothPage2(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("2 - drag photo")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage3(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("3 - choose default")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage4(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("4 - choose image")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage5(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("5 - choose color")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage6(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("6 - choose temp")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
    @ViewBuilder
    func CreateNewClothPage7(size: CGSize, index: Int) -> some View {
        CreateNewClothPage(size: size, index: index, title:"Upload cloth photo") {
            Text("7 - final")
        }
        .offset(x: -size.width * CGFloat(currentPage - index))
    }
    
}
