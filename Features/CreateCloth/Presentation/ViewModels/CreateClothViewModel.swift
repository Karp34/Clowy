//
//  CreateClothViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI
import FirebaseStorage
import Firebase
import VisionKit

@MainActor
final class CreateClothViewModel: ObservableObject {

    // MARK: - Published

    @Published var clothId: String = UUID().uuidString
    @Published var name: String = ""
    @Published var type: ClothesType = .blank
    @Published var color: String = "#FFFFFF"
    @Published var isDefault: Bool = false
    @Published var image: String = ""
    @Published var rawImage: UIImage? = nil
    @Published var temp: [Temperature] = []
    @Published var imageId: String = ""
    @Published var isCutting: Bool = false
    @Published var isDefaultPhoto: Bool = false
    @Published var currentPage: Int = 0
    @Published var userChangedName: Bool = false
    @Published var chosenImage: UIImage? = nil
    @Published var chosenDefaultImage: Image? = nil
    @Published var temperatureSelection: ClosedRange<CGFloat> = -5...15
    @Published var categoryTypePhotos: [String] = []
    @Published var detectedObjects: Set<ImageAnalysisInteraction.Subject> = []
    @Published var extractErrorMessage: IdentifiableMessage? = nil
    let defaultPhotoFlow = [0, 1, 2, 5, 6]
    let notDefaultPhotoFlow = [0, 2, 3, 4, 5, 6]

    var categoryNames: [String] = ClothesType.allCases
        .filter { $0 != .blank }
        .map { $0.rawValue }

    static let shared = CreateClothViewModel()

    private let repository: IClothRepository?

    init(repository: IClothRepository? = DIContainer.shared.clothRepository) {
        self.repository = repository
    }

    // MARK: - Reset

    func reset() {
        clothId = UUID().uuidString
        name = ""
        type = .blank
        color = "#FFFFFF"
        isDefault = false
        image = ""
        rawImage = nil
        temp = []
        imageId = ""
        isCutting = false
        isDefaultPhoto = false
        currentPage = 0
        userChangedName = false
        chosenImage = nil
        chosenDefaultImage = nil
        temperatureSelection = -5...15
        categoryTypePhotos = []
        detectedObjects = []
        extractErrorMessage = nil
    }

    // MARK: - Save
    enum ClothError: Error {
        case repositoryNotAvailable
    }

    func saveCloth() async throws {
        guard let repository else { throw ClothError.repositoryNotAvailable }
        
        let temperatureList = temp.compactMap { TemperatureType(rawValue: $0.name) }

        if !isDefault {
            try await uploadImage(fileName: clothId)
            try await repository.createCloth(CreateClothInput(
                id: clothId,
                name: name,
                type: type.rawValue,
                image: clothId,
                temperature: temperatureList,
                color: color,
                isDefault: false
            ))
        } else {
            try await repository.createCloth(CreateClothInput(
                id: clothId,
                name: name,
                type: type.rawValue,
                image: type.rawValue,
                temperature: temperatureList,
                color: color,
                isDefault: true
            ))
        }
        reset()
    }

    func updateCloth() async throws {
        guard let repository else { throw ClothError.repositoryNotAvailable }
        
        let temperatureList = temp.compactMap { TemperatureType(rawValue: $0.name) }

        if !isDefault {
            let imageFileName = imageId != "" ? imageId : image
            if imageId != "" {
                try await updateImage(imageId: imageId)
            }
            try await repository.updateCloth(CreateClothInput(
                id: clothId,
                name: name,
                type: type.rawValue,
                image: imageFileName,
                temperature: temperatureList,
                color: color,
                isDefault: false
            ))
        } else {
            try await repository.updateCloth(CreateClothInput(
                id: clothId,
                name: name,
                type: type.rawValue,
                image: type.rawValue,
                temperature: temperatureList,
                color: color,
                isDefault: true
            ))
        }
        reset()
    }

    // MARK: - Image

    private func uploadImage(fileName: String) async throws {
        guard let imageData = rawImage?.jpegData(compressionQuality: 0.5) else { return }
        let ref = Storage.storage().reference(withPath: fileName)
        _ = try await ref.putDataAsync(imageData)
    }

    private func deleteFromStorage(imageId: String) async throws {
        let ref = Storage.storage().reference().child(imageId)
        try await ref.delete()
    }

    private func updateImage(imageId: String) async throws {
        try await deleteFromStorage(imageId: imageId)
        try await uploadImage(fileName: imageId)
    }

    func loadCategoryPhotos() async {
        do {
            categoryTypePhotos = try await CategoryRemoteDataSource().fetchPhotos(for: type.rawValue)
        } catch {
            AppLogger.error(error, category: .network)
        }
    }
    // MARK: - Helpers

    var isValid: Bool {
        name.count > 2 && type != .blank && !temp.isEmpty
    }
    
    // MARK: - VisionKit

    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()

    func analyzeImage(_ image: UIImage) async throws -> Set<ImageAnalysisInteraction.Subject> {
        let configuration = ImageAnalyzer.Configuration([.visualLookUp])
        let analysis = try await analyzer.analyze(image, configuration: configuration)
        interaction.analysis = analysis
        return await interaction.subjects
    }

    // MARK: - Cloth name generation

    func createClothName() -> String {
        if !color.isEmpty && type != .blank {
            return getColorNameFromHex(color).capitalized + " " + type.rawValue
        }
        return TemperatureClothingDescriptor.getAdjective(for: temperatureSelection).capitalized + " " + type.rawValue
    }

    private func getColorNameFromHex(_ hex: String) -> String {
        let rgb = hexToRGB(hex)
        let basicColors: [(name: String, rgb: (r: Int, g: Int, b: Int))] = [
            ("red", (255, 0, 0)), ("green", (0, 255, 0)), ("blue", (0, 0, 255)),
            ("yellow", (255, 255, 0)), ("purple", (128, 0, 128)), ("orange", (255, 165, 0)),
            ("black", (0, 0, 0)), ("white", (255, 255, 255)), ("gray", (128, 128, 128)),
            ("pink", (255, 192, 203)), ("brown", (165, 42, 42)), ("light blue", (0, 255, 255))
        ]
        var minDistance = Double.infinity
        var closestColor = "unknown"
        for color in basicColors {
            let distance = colorDistance((r: rgb.r, g: rgb.g, b: rgb.b), (r: color.rgb.r, g: color.rgb.g, b: color.rgb.b))
            if distance < minDistance {
                minDistance = distance
                closestColor = color.name
            }
        }
        return closestColor
    }

    private func hexToRGB(_ hex: String) -> (r: Int, g: Int, b: Int) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        return (Int((rgb >> 16) & 0xFF), Int((rgb >> 8) & 0xFF), Int(rgb & 0xFF))
    }

    private func colorDistance(_ c1: (r: Int, g: Int, b: Int), _ c2: (r: Int, g: Int, b: Int)) -> Double {
        let rMean = Double(c1.r + c2.r) / 2
        let r = Double(c1.r - c2.r)
        let g = Double(c1.g - c2.g)
        let b = Double(c1.b - c2.b)
        return sqrt((2 + rMean/256) * pow(r, 2) + 4 * pow(g, 2) + (2 + (255-rMean)/256) * pow(b, 2))
    }
}
