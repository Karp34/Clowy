//
//  CreateOutfitView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI
import WaterfallGrid

struct CreateOutfitView: View {
    @EnvironmentObject private var wardrobeViewModel: WardrobeViewModel
    @EnvironmentObject private var outfitViewModel: OutfitViewModel
    @StateObject private var createViewModel = CreateOutfitViewModel()
    @Environment(\.presentationMode) private var presentationMode

    @State private var isEditingName = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    CreateOutfitNavBar(
                        showSaveButton: createViewModel.showSaveButton,
                        onBack: { presentationMode.wrappedValue.dismiss() },
                        onSave: { withAnimation { createViewModel.isSavingOutfit = true } }
                    )
                    outfitComposition
                }

                CustomSheetView(
                    radius: 32,
                    color: Color.primaryBackground,
                    clearCornerColor: .primaryBlueBrand,
                    topLeftCorner: true,
                    topRightCorner: false
                ) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer(minLength: 24)
                        if wardrobeViewModel.wardrobe.isEmpty {
                            WardrobeSkeleton()
                        } else {
                            VStack {
                                ForEach(wardrobeViewModel.wardrobe) { category in
                                    if category.items.isEmpty {
                                        emptyCategory(category.clothesTypeName.rawValue)
                                    } else {
                                        WardrobeCategorySection(
                                            clothesTypeName: category.clothesTypeName,
                                            clothes: category.items,
                                            selectedClothes: createViewModel.currentOutfit,
                                            delegate: createViewModel
                                        )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            }
            .navigationBarHidden(true)
            .background(Color.primaryBlueBrand.edgesIgnoringSafeArea(.all))

            if createViewModel.isSavingOutfit {
                saveOverlay
            }
        }
    }

    // MARK: - Outfit composition (top area)

    private var outfitComposition: some View {
        let sorted = sortedCurrentOutfit()
        return WaterfallGrid(sorted) { cloth in
            OutfitMiniCard(cloth: cloth)
        }
        .gridStyle(columns: 4, spacing: 13)
        .padding(.bottom, 16)
        .padding(.horizontal, 24)
    }

    // MARK: - Save overlay

    private var saveOverlay: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.white).opacity(0.01)
                .onTapGesture {
                    withAnimation {
                        createViewModel.isSavingOutfit = false
                        isEditingName = false
                    }
                }

            CustomSheetView(radius: 32, color: .white, clearCornerColor: Color.primaryBackground, topLeftCorner: true, topRightCorner: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Create outfit")
                        .font(.custom("Montserrat-SemiBold", size: 22))
                        .foregroundColor(Color.primaryGrey)
                        .padding(.top, 24)
                        .padding(.bottom, 12)

                    HStack(alignment: .top) {
                        TextField("Outfit name", text: $createViewModel.outfitName, onEditingChanged: { changed in
                            withAnimation { isEditingName = changed }
                        })
                        .textFieldStyle(CustomFieldStyle())
                        Spacer()
                        if createViewModel.outfitName.count > 2 {
                            ZStack {
                                Circle().frame(width: 18, height: 18).foregroundColor(Color.successGreen)
                                Image("Ok").resizable().scaledToFit().frame(width: 10, height: 10).foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom, 2)

                    Rectangle().frame(height: 1).foregroundColor(Color.separatorGrey).padding(.bottom, 32)

                    Button {
                        let ids = createViewModel.currentOutfit.map { $0.id }
                        Task {
                            await outfitViewModel.createOutfit(clothes: ids, name: createViewModel.outfitName)
                            presentationMode.wrappedValue.dismiss()
                            createViewModel.reset()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24).frame(height: 56).foregroundColor(.clear)
                            Text("SAVE").font(.custom("Montserrat-SemiBold", size: 16)).foregroundColor(.white)
                        }
                    }
                    .buttonStyle(DefaultColorButtonStyle(color: Color.primaryBlueBrand, radius: 24))
                    .disabled(createViewModel.outfitName.count < 2)
                    .padding(.bottom, 40)

                    Spacer(minLength: 1)
                }
                .padding(.horizontal, 24)
            }
            .frame(height: isEditingName ? 609 : 250)
        }
        .background(Color.primaryBackground)
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Helpers

    private func emptyCategory(_ name: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(name)
                .font(.custom("Montserrat-SemiBold", size: 22))
                .padding(.leading, 24)
                .foregroundColor(Color.primaryGrey)
            ScrollView(.horizontal, showsIndicators: false) {
                AddClothButton().padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
            }
        }
    }

    private func sortedCurrentOutfit() -> [Cloth] {
        let order = CreateDefaultWardrobe.getClothes()
        var sorted: [Cloth] = []
        for category in order {
            if let match = createViewModel.currentOutfit.first(where: { $0.type == category.clothesTypeName }) {
                sorted.append(match)
            }
        }
        return sorted
    }
}
