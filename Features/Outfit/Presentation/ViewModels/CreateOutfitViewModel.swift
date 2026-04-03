//
//  CreateOutfitViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

@MainActor
final class CreateOutfitViewModel: ObservableObject, WardrobeClothesCardCollectionDelegate {

    // MARK: - Published

    @Published var currentOutfit: [Cloth] = CreateOutfitViewModel.defaultPlaceholders
    @Published var outfitName: String = ""
    @Published var isSavingOutfit: Bool = false
    @Published var showSaveButton: Bool = false

    // MARK: - Defaults

    private static let defaultPlaceholders: [Cloth] = [
        Cloth(id: "1100", name: "", type: .tshirts,  color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultUpperWear", creationDate: 0),
        Cloth(id: "1101", name: "", type: .pants,    color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultPants",     creationDate: 0),
        Cloth(id: "1102", name: "", type: .sneakers, color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultSneaker",   creationDate: 0)
    ]

    private let upperTypes: [ClothesType] = [.hoodies, .jackets, .thermals, .tshirts, .dresses]
    private let lowerTypes: [ClothesType]  = [.pants, .skirts, .dresses]

    // MARK: - WardrobeClothesCardCollectionDelegate

    func appendToOutfit(cloth: Cloth) {
        if currentOutfit.contains(cloth) {
            removeAndRestorePlaceholder(cloth)
        } else {
            replaceSlotAndAppend(cloth)
        }
        syncShowSaveButton()
    }

    // MARK: - Reset

    func reset() {
        currentOutfit = Self.defaultPlaceholders
        outfitName = ""
        isSavingOutfit = false
        showSaveButton = false
    }

    // MARK: - Private

    private func replaceSlotAndAppend(_ cloth: Cloth) {
        if let sameTypeIndex = currentOutfit.firstIndex(where: { $0.type == cloth.type }) {
            currentOutfit.remove(at: sameTypeIndex)
        } else if upperTypes.contains(cloth.type), let i = currentOutfit.firstIndex(where: { $0.id == "1100" }) {
            currentOutfit.remove(at: i)
        } else if lowerTypes.contains(cloth.type), let i = currentOutfit.firstIndex(where: { $0.id == "1101" }) {
            currentOutfit.remove(at: i)
        }
        currentOutfit.append(cloth)
    }

    private func removeAndRestorePlaceholder(_ cloth: Cloth) {
        guard let index = currentOutfit.firstIndex(where: { $0.type == cloth.type }) else { return }
        currentOutfit.remove(at: index)

        let currentTypes = Set(currentOutfit.map { $0.type })
        let hasUpper = currentTypes.isDisjoint(with: upperTypes) == false

        for placeholder in Self.defaultPlaceholders {
            if placeholder.id == "1100", !hasUpper, !currentOutfit.contains(placeholder) {
                currentOutfit.append(placeholder)
            }
            if placeholder.id == "1101" {
                let hasLower = !currentTypes.isDisjoint(with: lowerTypes)
                if !hasLower, !currentOutfit.contains(placeholder) { currentOutfit.append(placeholder) }
            }
            if placeholder.id == "1102", !currentTypes.contains(.sneakers), !currentOutfit.contains(placeholder) {
                currentOutfit.append(placeholder)
            }
        }
    }

    private func syncShowSaveButton() {
        showSaveButton = !currentOutfit.contains(where: { Self.defaultPlaceholders.contains($0) })
    }
}
