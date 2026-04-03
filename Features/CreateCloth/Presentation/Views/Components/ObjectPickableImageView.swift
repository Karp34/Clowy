//
//  ObjectPickableImageView.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import UIKit
import SwiftUI
import VisionKit

// UIKit bridge that displays an image with VisionKit interaction support
// (subject highlighting, drag-to-copy, etc.).
//
// Usage:
// ```swift
// ObjectPickableImageView(image: uiImage)
//     .environmentObject(viewModel)
//     .frame(height: 350)
//     .scaledToFit()
//     .cornerRadius(20)
// ```
struct ObjectPickableImageView: UIViewRepresentable {

    let image: UIImage

    @EnvironmentObject private var viewModel: ImageAnalysisViewModel

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> _ZeroIntrinsicImageView {
        let imageView = _ZeroIntrinsicImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        viewModel.interaction.preferredInteractionTypes = [.imageSubject]
        imageView.addInteraction(viewModel.interaction)

        return imageView
    }

    func updateUIView(_ uiView: _ZeroIntrinsicImageView, context: Context) {
        // Only update the image if it actually changed to avoid resetting VisionKit state.
        if uiView.image !== image {
            uiView.image = image
        }
    }
}

// MARK: - Helper

// `UIImageView` with zero `intrinsicContentSize` so the SwiftUI layout
// does not conflict with sizes set via `.frame()`.
final class _ZeroIntrinsicImageView: UIImageView {
    override var intrinsicContentSize: CGSize { .zero }
}
