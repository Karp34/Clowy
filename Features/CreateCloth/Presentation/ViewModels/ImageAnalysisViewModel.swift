//
//  ImageAnalysisViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import UIKit
import VisionKit

@MainActor
final class ImageAnalysisViewModel: NSObject, ObservableObject {

    // MARK: - Public state

    // All subjects detected in the most recently analyzed image.
    @Published private(set) var detectedSubjects: Set<ImageAnalysisInteraction.Subject> = []

    // The latest analysis error. The View observes this and presents an alert.
    @Published var analysisError: ImageAnalysisError?

    // MARK: - VisionKit internals

    // Exposed as `internal` so ObjectPickableImageView can call addInteraction(_:).
    let interaction = ImageAnalysisInteraction()

    private let analyzer = ImageAnalyzer()

    // MARK: - Public API

    // Analyzes the given image and updates `detectedSubjects`.
    // Returns the found subjects for the caller's convenience.

    @discardableResult
    func analyzeImage(_ image: UIImage) async throws -> Set<ImageAnalysisInteraction.Subject> {
        let configuration = ImageAnalyzer.Configuration([.visualLookUp])
        let analysis = try await analyzer.analyze(image, configuration: configuration)
        interaction.analysis = analysis
        let subjects = await interaction.subjects
        detectedSubjects = subjects
        return subjects
    }

    // Toggles highlight on the given subject; removes it if already highlighted.
    func toggleHighlight(for subject: ImageAnalysisInteraction.Subject) {
        if interaction.highlightedSubjects.contains(subject) {
            interaction.highlightedSubjects.remove(subject)
        } else {
            interaction.highlightedSubjects.insert(subject)
        }
    }

    // Removes highlight from all subjects.
    func clearHighlights() {
        interaction.highlightedSubjects.removeAll()
    }

    // Extracts a standalone image for the given subject (background removed).
    func extractImage(for subject: ImageAnalysisInteraction.Subject) async -> UIImage? {
        try? await subject.image
    }

    // Builds a composite image from all currently highlighted subjects.
    func imageForHighlightedSubjects() async throws -> UIImage {
        try await interaction.image(for: interaction.highlightedSubjects)
    }
}

// MARK: - Error

enum ImageAnalysisError: LocalizedError, Identifiable {
    case analysisFailed(String)
    case imageLoadFailed

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .analysisFailed(let message): return message
        case .imageLoadFailed: return "Failed to load the selected image."
        }
    }
}
