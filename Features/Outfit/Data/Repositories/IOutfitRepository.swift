//
//  IOutfitRepository.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import Foundation

protocol IOutfitRepository {
    func fetchOutfits() async throws -> [Outfit]
    func createOutfit(clothes: [String], name: String, isGenerated: Bool) async throws
}
