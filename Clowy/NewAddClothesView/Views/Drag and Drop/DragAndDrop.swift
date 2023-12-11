//
//  Drag and Drop.swift
//  Clowy
//
//  Created by Egor Karpukhin on 10/12/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct DragAndDrop: View {
    @State private var previewImage: UIImage?
    
    var onImageChange: (UIImage) -> ()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
                
                VStack {
                    if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(4)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.largeTitle)
                                .imageScale(.large)
                                .foregroundColor(Color(hex: "#606060"))
                            
                            Text("Drag & Drop")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#606060"))
                        }
                        
                    }
                }
            }
            .background(Color(hex: "#F7F8FA"))
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    previewImage = droppedImage
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
        }
    }
    
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailmage = await image.byPreparingThumbnail(ofSize: size)
            await MainActor.run {
                previewImage = thumbnailmage
            }
        }
    }
}
