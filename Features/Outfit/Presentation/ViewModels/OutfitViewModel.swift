//
//  OutfitViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//
import SwiftUI

@MainActor
final class OutfitViewModel: ObservableObject {

    // MARK: - Published

    @Published var outfits: [Outfit] = []
    @Published var outfitState: PlaceHolderState = .placeholder

    // MARK: - Dependencies

    private let outfitRepository: IOutfitRepository?
    private let clothRepository: IClothRepository?

    init(
        outfitRepository: IOutfitRepository? = DIContainer.shared.outfitRepository,
        clothRepository: IClothRepository? = DIContainer.shared.clothRepository
    ) {
        self.outfitRepository = outfitRepository
        self.clothRepository = clothRepository
    }

    // MARK: - Fetch

    func fetchOutfits() async {
        guard let outfitRepository else { return }
        outfits.removeAll()
        outfitState = .placeholder
        do {
            outfits = try await outfitRepository.fetchOutfits()
            outfitState = .success
        } catch {
            outfitState = .error
            AppLogger.error(error, category: .network)
        }
    }

    // MARK: - Create

    func createOutfit(clothes: [String], name: String, isGenerated: Bool = false) async {
        guard let outfitRepository else { return }
        do {
            try await outfitRepository.createOutfit(clothes: clothes, name: name, isGenerated: isGenerated)
            await fetchOutfits()
        } catch {
            AppLogger.error(error, category: .network)
        }
    }

    // MARK: - Clothes

    func getClothesByIds(_ ids: [String]) -> [Cloth] {
        clothRepository?.getClothesByIds(ids) ?? []
    }
}
