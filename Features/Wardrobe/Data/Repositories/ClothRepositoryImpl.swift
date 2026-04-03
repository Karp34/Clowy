//
//  ClothRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

final class ClothRepositoryImpl: IClothRepository {
    private let remoteDataSource: ClothRemoteDataSource
    private var cachedClothes: [Cloth] = []

    init(remoteDataSource: ClothRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchClothes() async throws -> [Cloth] {
        let dtos = try await remoteDataSource.fetchClothes()
        cachedClothes = dtos.map { ClothMapper.toDomain($0) }
        return cachedClothes
    }

    func fetchWardrobe() async throws -> [Wardrobe] {
        let clothes = try await fetchClothes()
        return CreateDefaultWardrobe.getClothes().map { type in
            Wardrobe(
                id: type.id,
                clothesTypeName: type.clothesTypeName,
                items: clothes.filter { $0.type == type.clothesTypeName },
                ratio: GetRatio.getRatio(type: type.clothesTypeName)
            )
        }
    }

    func deleteCloth(_ cloth: Cloth) async throws {
        try await remoteDataSource.deleteCloth(id: cloth.id)
        try await remoteDataSource.deleteFromStorage(imageName: cloth.image)
        cachedClothes.removeAll { $0.id == cloth.id }
    }

    func getClothesByIds(_ ids: [String]) -> [Cloth] {
        let defaultClothes: [String: Cloth] = [
            "1100": Cloth(id: "1100", name: "", type: .tshirts,  color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultUpperWear", creationDate: 0),
            "1101": Cloth(id: "1101", name: "", type: .pants,    color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultPants",     creationDate: 0),
            "1102": Cloth(id: "1102", name: "", type: .sneakers, color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultSneaker",   creationDate: 0)
        ]
        return ids.compactMap { id in
            defaultClothes[id] ?? cachedClothes.first { $0.id == id }
        }
    }

    func getImageURL(for imageName: String) async throws -> URL {
        try await remoteDataSource.getDownloadURL(for: imageName)
    }
    
    func createCloth(_ input: CreateClothInput) async throws {
        try await remoteDataSource.createCloth(input)
        let newCloth = Cloth(
            id: input.id,
            name: input.name,
            type: ClothesType(rawValue: input.type) ?? .blank,
            color: input.color,
            temperature: input.temperature,
            isDefault: input.isDefault,
            image: input.image,
            creationDate: Int(Date().timeIntervalSince1970)
        )
        cachedClothes.append(newCloth)
    }

    func updateCloth(_ input: CreateClothInput) async throws {
        try await remoteDataSource.updateCloth(input)
        if let index = cachedClothes.firstIndex(where: { $0.id == input.id }) {
            cachedClothes[index] = Cloth(
                id: input.id,
                name: input.name,
                type: ClothesType(rawValue: input.type) ?? .blank,
                color: input.color,
                temperature: input.temperature,
                isDefault: input.isDefault,
                image: input.image,
                creationDate: Int(Date().timeIntervalSince1970)
            )
        }
    }
}
