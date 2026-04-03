//
//  RemoveBackgroundView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI
import VisionKit

struct RemoveBackgroundView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    var body: some View {
        if let rawImage = viewModel.rawImage {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondaryBlueBrand, style: StrokeStyle(lineWidth: 1, dash: [11]))
                ZStack {
                    Image(uiImage: rawImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)

                    HStack(alignment: .top) {
                        Spacer()
                        VStack {
                            Image(systemName: "trash")
                                .foregroundColor(Color.errorRed)
                                .frame(width: 20, height: 20)
                                .padding(16)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.rawImage = nil
                            viewModel.isDefault = false
                            viewModel.imageId = viewModel.image
                            viewModel.image = ""
                            viewModel.chosenImage = nil
                        }
                    }
                }
            }
            .aspectRatio(0.8, contentMode: .fit)
            .background(Color.primaryBackground)
            .alert(item: $viewModel.extractErrorMessage) { message in
                Alert(title: Text("Error while analyzing objects within the image"), message: Text(message.value))
            }

        } else if viewModel.isCutting {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondaryBlueBrand, style: StrokeStyle(lineWidth: 1, dash: [11]))
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Removing background...")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color.primaryGrey)
                }
            }
            .aspectRatio(0.8, contentMode: .fit)

        } else {
            ImagePickerV2 { image in
                viewModel.chosenImage = image
            }
            .aspectRatio(0.8, contentMode: .fit)
            .onChange(of: viewModel.chosenImage) { oldValue, newValue in
                guard let image = newValue else { return }
                Task { @MainActor in
                    do {
                        viewModel.detectedObjects = try await viewModel.analyzeImage(image)
                        if let objectImage = try? await viewModel.detectedObjects.first?.image {
                            withAnimation {
                                viewModel.isCutting = false
                                viewModel.rawImage = objectImage
                            }
                        }
                    } catch {
                        viewModel.isCutting = false
                        viewModel.extractErrorMessage = IdentifiableMessage(error.localizedDescription)
                    }
                }
            }
        }
    }
}
