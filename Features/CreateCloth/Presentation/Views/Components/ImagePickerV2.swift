//
//  ImagePicker.swift
//  lift-subjects-from-images
//
//  Created by Egor Karpukhin on 09/12/2023.
//

import SwiftUI
import PhotosUI

struct ImagePickerV2: View {
    var onImageChange: (UIImage) -> ()
    @EnvironmentObject var viewModel: CreateClothViewModel

    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        GeometryReader {
            let size = $0.size

            ZStack {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16).stroke(Color.secondaryGrey, lineWidth: 1)
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 46, height: 46)
                            .foregroundColor(Color.primaryBlueBrand)
                            .opacity(0.1)
                        Image(systemName: "photo")
                            .foregroundColor(Color.primaryBlueBrand)
                    }
                    Text("Use photo\nfrom galery")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color.primaryBlueBrand)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .onTapGesture {
                withAnimation { viewModel.currentPage = 1 }
                if !viewModel.isDefaultPhoto {
                    viewModel.reset()
                    viewModel.isDefaultPhoto = true
                }
                if viewModel.rawImage == nil {
                    showImagePicker.toggle()
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .optionalViewModifier { contentView in
                contentView
                    .onChange(of: photoItem) { oldValue, newValue in
                        if let newValue {
                            viewModel.isCutting = true
                            extractImage(newValue, size)
                        }
                    }
            }
        }
    }

    func extractImage(_ photoItem: PhotosPickerItem, _ viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    onImageChange(selectedImage)
                }
                self.photoItem = nil
            }
        }
    }
}
