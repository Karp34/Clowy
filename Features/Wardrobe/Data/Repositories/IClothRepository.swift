//
//  IClothRepository.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

protocol IClothRepository {
    func fetchWardrobe() async throws -> [Wardrobe]
    func fetchClothes() async throws -> [Cloth]
    func deleteCloth(_ cloth: Cloth) async throws
    func getClothesByIds(_ ids: [String]) -> [Cloth]
    func getImageURL(for imageName: String) async throws -> URL
    func createCloth(_ input: CreateClothInput) async throws
    func updateCloth(_ input: CreateClothInput) async throws
}
