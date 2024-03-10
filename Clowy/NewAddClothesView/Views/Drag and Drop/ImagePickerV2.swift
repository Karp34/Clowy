//
//  ImagePicker.swift
//  lift-subjects-from-images
//
//  Created by Egor Karpukhin on 09/12/2023.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct ImagePickerV2: View {
    
    var onImageChange: (UIImage) -> ()
    @ObservedObject var viewModel = AddClothesViewModel.shared
    
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            UsePhotoFromGalary()
            .onTapGesture {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            
            .optionalViewModifier{ contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: photoItem) { newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem) {newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
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

//#Preview {
//    ImagePicker()
//}

extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}
