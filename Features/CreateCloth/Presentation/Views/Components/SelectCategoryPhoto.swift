//
//  SelectCategoryPhoto.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.11.2024.
//
import SwiftUI

struct SelectCategoryPhoto: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.categoryTypePhotos, id: \.self) { photoName in
                SelectCategoryPhotoCell(
                    photoName: photoName,
                    isSelected: viewModel.image == photoName,
                    clothType: viewModel.type
                ) { image in
                    viewModel.image = photoName
                    viewModel.chosenDefaultImage = image
                }
            }
        }
        .onChange(of: viewModel.currentPage) { oldValue, newValue in
            if newValue == 3 {
                Task { await viewModel.loadCategoryPhotos() }
            }
        }
    }
}

private struct SelectCategoryPhotoCell: View {
    let photoName: String
    let isSelected: Bool
    let clothType: ClothesType
    let onSelect: (Image?) -> Void

    @State private var loadedImage: Image? = nil

    var body: some View {
        Button {
            onSelect(loadedImage)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primaryBlueBrand.opacity(isSelected ? 1 : 0), lineWidth: 2)
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                            .onAppear { loadedImage = image }
                    case .failure:
                        Image(systemName: "exclamationmark.triangle").foregroundColor(.red)
                    default:
                        ProgressView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
            .aspectRatio(GetRatio.getRatio(type: clothType).rawValue, contentMode: .fit)
            .shadow(color: Color.shadowGrey.opacity(0.05), radius: 8, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var photoURL: URL? {
        // токен убран — URL берётся через Firebase SDK в CategoryRemoteDataSource
        URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-app-17e8c.appspot.com/o/categories%2F\(photoName)?alt=media")
    }
}
