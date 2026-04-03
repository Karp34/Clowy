//
//  ObjectExtractionView.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

//  NOTE: This screen is used for debugging and prototyping VisionKit.
//  In the production CreateCloth flow the logic is called directly from CreateClothViewModel.
//

import SwiftUI
import PhotosUI
import VisionKit

struct ObjectExtractionView: View {

    // MARK: - State

    @StateObject private var viewModel = ImageAnalysisViewModel()

    @State private var pickedImage: UIImage?
    @State private var pickedItems: [PhotosPickerItem] = []

    @State private var extractedSingleImage: UIImage?
    @State private var extractedAllImage: UIImage?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imagePicker
                if let pickedImage {
                    interactiveImageSection(pickedImage)
                }
                extractedImagesRow
                detectedSubjectsGrid
            }
            .padding()
        }
        // ImageAnalysisError is Identifiable — no need for String: Identifiable extension
        .alert(item: $viewModel.analysisError) { error in
            Alert(
                title: Text("Analysis Error"),
                message: Text(error.localizedDescription)
            )
        }
    }

    // MARK: - Subviews

    private var imagePicker: some View {
        PhotosPicker(
            selection: $pickedItems,
            maxSelectionCount: 1,
            matching: .images
        ) {
            Label("Pick Image", systemImage: "photo")
        }
        .onChange(of: pickedItems) { _, newValue in
            Task { @MainActor in
                await loadAndAnalyze(newValue)
            }
        }
    }

    private func interactiveImageSection(_ image: UIImage) -> some View {
        VStack(spacing: 8) {
            Text("Tap an object to select it")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ObjectPickableImageView(image: image)
                .scaledToFit()
                .cornerRadius(20)
                .frame(height: 350)
                .environmentObject(viewModel)
                .onTapGesture { location in
                    Task { @MainActor in
                        await handleTap(at: location)
                    }
                }
        }
    }

    @ViewBuilder
    private var extractedImagesRow: some View {
        if extractedSingleImage != nil || extractedAllImage != nil {
            HStack(spacing: 16) {
                if let single = extractedSingleImage {
                    extractedImageCard(single, title: "Single object")
                }
                if let all = extractedAllImage {
                    extractedImageCard(all, title: "All selected")
                }
            }
        }
    }

    private func extractedImageCard(_ image: UIImage, title: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.teal))
                .frame(height: 280)
        }
    }

    private var detectedSubjectsGrid: some View {
        VStack(spacing: 8) {
            Text("Detected objects: \(viewModel.detectedSubjects.count)")
                .font(.headline)

            // Sorted left-to-right; id: \.hashValue avoids the String: Identifiable extension
            let sorted = viewModel.detectedSubjects.sorted { $0.bounds.minX < $1.bounds.minX }

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                ForEach(sorted, id: \.hashValue) { subject in
                    SubjectCard(subject: subject) {
                        // Toggle highlight on
                        viewModel.toggleHighlight(for: subject)
                        Task { await refreshAllSelectedImage() }
                    } onExtract: {
                        // Extract a single subject image
                        Task {
                            extractedSingleImage = await viewModel.extractImage(for: subject)
                        }
                    } onDeselect: {
                        // Toggle highlight off
                        viewModel.toggleHighlight(for: subject)
                        Task { await refreshAllSelectedImage() }
                    }
                }
            }

            Text("Long press on an object in the image to copy.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Actions

    private func loadAndAnalyze(_ items: [PhotosPickerItem]) async {
        do {
            guard
                let data = try await items.first?.loadTransferable(type: Data.self),
                let image = UIImage(data: data)
            else { return }

            pickedImage = image
            try await viewModel.analyzeImage(image)
        } catch {
            // analysisError is published inside the ViewModel;
            // forward here via a separate @State if the View needs to react differently
        }
    }

    private func handleTap(at location: CGPoint) async {
        guard let subject = await viewModel.interaction.subject(at: location) else { return }
        viewModel.toggleHighlight(for: subject)
        await refreshAllSelectedImage()
    }

    private func refreshAllSelectedImage() async {
        extractedAllImage = try? await viewModel.imageForHighlightedSubjects()
    }
}

// MARK: - SubjectCard

/// A card representing a single detected subject.
/// Extracted into its own component to keep the parent View body readable.
private struct SubjectCard: View {
    let subject: ImageAnalysisInteraction.Subject
    let onSelect: () -> Void
    let onExtract: () -> Void
    let onDeselect: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("x: \(Int(subject.bounds.origin.x))  y: \(Int(subject.bounds.origin.y))")
                .font(.caption2)
            Text("w: \(Int(subject.bounds.width))  h: \(Int(subject.bounds.height))")
                .font(.caption2)
            Text("hash: \(subject.hashValue)")
                .font(.caption2)
                .lineLimit(1)

            HStack(spacing: 8) {
                Button("Select", action: onSelect)
                Button("Extract", action: onExtract)
                Button("Remove", action: onDeselect)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.borderless)
            .font(.caption)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(uiColor: .systemGroupedBackground))
        )
    }
}
