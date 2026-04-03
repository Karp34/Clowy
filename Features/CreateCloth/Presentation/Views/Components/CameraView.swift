//
//  CameraView.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import SwiftUI

struct CameraView: View {

    @StateObject var viewModel = CameraViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Live camera feed or captured photo preview
            if let captured = viewModel.capturedImage {
                Image(uiImage: captured)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                CameraPreview(session: viewModel.cameraService.session)
                    .ignoresSafeArea()
            }

            VStack {
                topBar
                Spacer()
                frameGuide
                Spacer()
                bottomBar
            }
        }
        .task { await viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .alert("Camera Access Denied", isPresented: $viewModel.showPermissionAlert) {
            Button("Open Settings") { openSettings() }
            Button("Cancel", role: .cancel) { dismiss() }
        } message: {
            Text("Please enable camera access in Settings to take photos.")
        }
        .alert(item: $viewModel.captureError) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var topBar: some View {
        if viewModel.capturedImage != nil {
            HStack {
                Spacer()
                Button {
                    viewModel.retake()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
        }
    }

    private var frameGuide: some View {
        RoundedRectangle(cornerRadius: 32)
            .stroke(Color.separatorGrey, style: StrokeStyle(lineWidth: 1, dash: [4]))
            .frame(width: 300, height: 600)
    }

    @ViewBuilder
    private var bottomBar: some View {
        HStack {
            if viewModel.capturedImage != nil {
                saveButton
                Spacer()
            } else {
                Spacer()
                shutterButton
                Spacer()
            }
        }
        .frame(height: 75)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var saveButton: some View {
        Button {
            if viewModel.isSaved {
                dismiss()
            } else {
                viewModel.savePhoto()
            }
        } label: {
            Text(viewModel.isSaved ? "Saved" : "Save")
                .foregroundColor(.black)
                .fontWeight(.semibold)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .padding(.leading)
    }

    private var shutterButton: some View {
        Button {
            Task { await viewModel.takePhoto() }
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 65, height: 65)
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 75, height: 75)
            }
        }
    }

    // MARK: - Helpers

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
