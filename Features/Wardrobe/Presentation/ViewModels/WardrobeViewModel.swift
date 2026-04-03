import SwiftUI

@MainActor
final class WardrobeViewModel: ObservableObject {

    // MARK: - Published

    @Published var wardrobe: [Wardrobe] = []
    @Published var wardrobeState: PlaceHolderState = .placeholder
    @Published var imageURLs: [String: URL] = [:]

    // MARK: - Dependencies

    private let repository: IClothRepository?

    init(repository: IClothRepository? = DIContainer.shared.clothRepository) {
        self.repository = repository
    }

    // MARK: - Wardrobe

    func fetchWardrobe() async {
        guard let repository else {
            AppLogger.log("WardrobeViewModel: repository is nil")
            return
        }
        wardrobeState = .placeholder
        do {
            wardrobe = try await repository.fetchWardrobe()
            wardrobeState = .success
        } catch {
            wardrobeState = .error
            AppLogger.log("fetchWardrobe error: \(error)")
        }
    }

    // MARK: - Delete

    func deleteCloth(_ cloth: Cloth) async {
        guard let repository else { return }
        do {
            try await repository.deleteCloth(cloth)
            if let index = wardrobe.firstIndex(where: { $0.clothesTypeName == cloth.type }) {
                wardrobe[index].deleteCloth(cloth)
            }
        } catch {
            AppLogger.log("deleteCloth error: \(error)")
        }
    }

    // MARK: - Image URLs

    func loadImageURL(for imageName: String) async {
        guard let repository else { return }
        guard imageURLs[imageName] == nil else { return }
        do {
            let url = try await repository.getImageURL(for: imageName)
            imageURLs[imageName] = url
        } catch {
            AppLogger.log("loadImageURL error: \(error)")
        }
    }
}
