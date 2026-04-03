//
//  OutfitRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import Foundation

final class OutfitRepositoryImpl: IOutfitRepository {
    private let remoteDataSource: OutfitRemoteDataSource

    init(remoteDataSource: OutfitRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchOutfits() async throws -> [Outfit] {
        let dtos = try await remoteDataSource.fetchOutfits()
        return dtos.map { OutfitMapper.toDomain($0) }
    }

    func createOutfit(clothes: [String], name: String, isGenerated: Bool) async throws {
        try await remoteDataSource.createOutfit(clothes: clothes, name: name, isGenerated: isGenerated)
    }
}
