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
    @ObservedObject var viewModel = CreateNewClothViewModel.shared
    
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex:"F1F1F1"), lineWidth: 1)
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
                if viewModel.cloth.rawImage == nil {
                    showImagePicker.toggle()
                    
                }
                withAnimation {
                    viewModel.currentPage = 1
                    viewModel.isDefaultPhoto = true
                }
                
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            
            .optionalViewModifier{ contentView in
                contentView
                    .onChange(of: photoItem) { oldValue, newValue in
                        if let newValue {
                            extractImage(newValue, size)
                        }
                    }
            }
        }
    }
    
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailmage = await image.byPreparingThumbnail(ofSize: size)
            await MainActor.run {
                viewModel.cloth.rawImage = thumbnailmage
            }
        }
    }
    
    func extractImage(_ photoItem: PhotosPickerItem, _ viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else {
                return
            }
            
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    generateImageThumbnail(selectedImage, viewSize)
                    onImageChange(selectedImage)
                }
                self.photoItem = nil
            }
            
        }
    }
}

extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}
