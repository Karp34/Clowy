//
//  WardrobeClothesCardCollectionDelegate.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

protocol WardrobeClothesCardCollectionDelegate {
    func appendToOutfit(cloth: Cloth)
}

struct WardrobeCategorySection: View {
    @EnvironmentObject private var viewModel: WardrobeViewModel

    var clothesTypeName: ClothesType
    var clothes: [Cloth]
    var selectedClothes: [Cloth]? = []
    var delegate: WardrobeClothesCardCollectionDelegate?

    @State private var editableCloth: Cloth?
    @State private var showingAlert = false
    @State private var isShowingEditSheet = false
    @State private var isShowingAddSheet = false

    private let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
    private var sortedClothes: [Cloth] { clothes.sorted { $0.creationDate < $1.creationDate } }

    var body: some View {
        if let selectedClothes, !selectedClothes.isEmpty {
            outfitSelectionMode
        } else {
            normalMode
        }
    }

    // MARK: - Outfit selection mode

    private var outfitSelectionMode: some View {
        VStack(alignment: .leading, spacing: 0) {
            categoryTitle
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sortedClothes) { cloth in
                        WardrobeClothesCard(cloth: cloth)
                            .onTapGesture { delegate?.appendToOutfit(cloth: cloth) }
                    }
                    AddClothButton()
                }
                .padding(insets)
            }
        }
    }

    // MARK: - Normal mode

    private var normalMode: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                categoryTitle
                if !clothes.isEmpty {
                    Spacer()
                    Image("Edit")
                        .resizable()
                        .foregroundColor(Color.primaryGrey)
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                        .padding(.trailing, 16)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sortedClothes) { cloth in
                        WardrobeClothesCard(cloth: cloth)
                            .contextMenu {
                                contextMenuItems.onAppear { editableCloth = cloth }
                            }
                            .alert(isPresented: $showingAlert) { deleteAlert }
                    }
                    AddClothButton()
                        .onTapGesture { isShowingAddSheet.toggle() }
                        .sheet(isPresented: $isShowingAddSheet) {
                            CreateNewClothView(isShowingSheet: $isShowingAddSheet)
                        }
                }
                .padding(insets)
            }
            .sheet(isPresented: $isShowingEditSheet) {
                if let editableCloth {
                    CreateNewClothView(
                        isEditingCloth: true,
                        cloth: editableCloth,
                        isShowingSheet: $isShowingEditSheet
                    )
                }
            }
        }
    }

    // MARK: - Subviews

    private var categoryTitle: some View {
        Text(clothesTypeName.rawValue)
            .font(.custom("Montserrat-SemiBold", size: 22))
            .padding(.leading, 24)
            .foregroundColor(Color.primaryGrey)
    }

    private var contextMenuItems: some View {
        Group {
            Button {
                isShowingEditSheet.toggle()
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            Button {
                showingAlert = true
            } label: {
                Label("Delete", systemImage: "trash").tint(.red)
            }
        }
    }

    private var deleteAlert: Alert {
        Alert(
            title: Text("Delete cloth"),
            message: Text("Do you want to delete this cloth?"),
            primaryButton: .default(Text("No")),
            secondaryButton: .default(Text("Yes")) {
                if let cloth = editableCloth {
                    Task { await viewModel.deleteCloth(cloth) }
                }
            }
        )
    }
}
