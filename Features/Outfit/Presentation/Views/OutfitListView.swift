//
//  OutfitListView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct OutfitListView: View {
    @EnvironmentObject private var viewModel: OutfitViewModel
    @Environment(\.presentationMode) private var presentationMode

    @State private var isShowingCreate = false

    var body: some View {
        VStack {
            switch viewModel.outfitState {
            case .placeholder:
                ScrollView(.vertical, showsIndicators: false) { OutfitListSkeleton() }
            case .error:
                OutfitErrorView { Task { await viewModel.fetchOutfits() } }
            case .success:
                if viewModel.outfits.isEmpty {
                    OutfitEmptyView(onCreateTap: { isShowingCreate = true })
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            let sorted = viewModel.outfits.sorted { ($0.createDTM ?? 0) < ($1.createDTM ?? 0) }
                            ForEach(sorted) { outfit in
                                let clothes = viewModel.getClothesByIds(outfit.clothes)
                                if !clothes.isEmpty {
                                    OutfitRow(outfitName: outfit.name, clothes: clothes)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("My outfits")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: backButton, trailing: addButton)
        .navigationBarBackButtonHidden(true)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isShowingCreate) { CreateOutfitView() }
        .task { await viewModel.fetchOutfits() }
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
        Button { isShowingCreate = true } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8).foregroundColor(.white)
                Image(systemName: "plus")
                    .foregroundColor(Color.primaryGrey)
                    .frame(width: 32, height: 32)
            }
        }
    }
}
