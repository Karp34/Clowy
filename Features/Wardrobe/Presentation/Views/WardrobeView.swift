//
//  WardrobeView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject private var viewModel: WardrobeViewModel
    @Environment(\.presentationMode) private var presentationMode

    var excludedClothes: [String] = []

    @State private var isShowingAddSheet = false

    init(excludedClothes: [String] = []) {
        self.excludedClothes = excludedClothes
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont(name: "Montserrat-Bold", size: 14)!]
        appearance.backgroundColor = UIColor(Color.primaryBackground)
        appearance.shadowColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(name: "Montserrat-Bold", size: 14)!,
            .foregroundColor: UIColor(Color(hex: "#FFFFFF"))
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch viewModel.wardrobeState {
            case .placeholder:
                WardrobeSkeleton()
            case .success:
                VStack {
                    ForEach(viewModel.wardrobe) { category in
                        if !excludedClothes.contains(category.clothesTypeName.rawValue.lowercased()) {
                            WardrobeCategorySection(
                                clothesTypeName: category.clothesTypeName,
                                clothes: category.items
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error:
                WardrobeEmptyView(accentColor: Color.primaryBlueBrand)
            }
        }
        .navigationBarTitle("My Wardrobe")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: backButton, trailing: addButton)
        .navigationBarBackButtonHidden(true)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .task { await viewModel.fetchWardrobe() }
    }

    private var backButton: some View {
        Button { presentationMode.wrappedValue.dismiss() } label: {
            Image("back_button")
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .contentShape(Rectangle())
                .foregroundColor(.black)
        }
    }

    private var addButton: some View {
        Button { isShowingAddSheet.toggle() } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8).foregroundColor(.white)
                Image(systemName: "plus")
                    .foregroundColor(Color.primaryGrey)
                    .frame(width: 32, height: 32)
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            CreateNewClothView(isShowingSheet: $isShowingAddSheet)
        }
    }
}
