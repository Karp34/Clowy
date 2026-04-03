//
//  CameraPreview.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import SwiftUI
@preconcurrency import AVFoundation
 
// Embeds an `AVCaptureVideoPreviewLayer` into the SwiftUI layout.
// Session lifecycle is managed externally by `CameraViewModel` — this view
// is purely responsible for attaching the preview layer to the view hierarchy.
struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.previewLayer.session = session
    }
}

final class PreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
