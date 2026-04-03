//
//  ChooseFlowView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//
import SwiftUI
import VisionKit

struct ChooseFlowView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    var body: some View {
        VStack {
            ImagePickerV2 { image in
                viewModel.chosenImage = image
            }
            .frame(height: 130)
            .shadow(color: Color.shadowGrey.opacity(0.05), radius: 8, y: 4)
            .onChange(of: viewModel.chosenImage) { oldValue, newValue in
                Task { @MainActor in
                    do {
                        if let image = viewModel.chosenImage {
                            viewModel.detectedObjects = try await viewModel.analyzeImage(image)
                            if let objectImage = try? await viewModel.detectedObjects.first?.image {
                                withAnimation {
                                    viewModel.isCutting = false
                                    viewModel.rawImage = objectImage
                                }
                            }
                        }
                    } catch {
                        viewModel.isCutting = false
                        viewModel.extractErrorMessage = IdentifiableMessage(error.localizedDescription)
                    }
                }
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16).stroke(Color.secondaryGrey, lineWidth: 1)
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 46, height: 46)
                            .foregroundColor(Color.primaryBlueBrand)
                            .opacity(0.1)
                        Image(systemName: "tshirt")
                            .foregroundColor(Color.primaryBlueBrand)
                    }
                    Text("Use basic photo")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color.primaryBlueBrand)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .frame(height: 130)
            .shadow(color: Color.shadowGrey.opacity(0.05), radius: 8, y: 4)
            .onTapGesture {
                withAnimation { viewModel.currentPage = 2 }
                if viewModel.isDefaultPhoto {
                    viewModel.reset()
                    viewModel.isDefaultPhoto = false
                }
            }
        }
    }
}
