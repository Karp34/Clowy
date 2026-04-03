//
//  Untitled.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

protocol ICreateClothRepository {
    func createCloth(_ input: CreateClothInput) async throws
    func updateCloth(_ input: CreateClothInput) async throws
    func uploadImage(data: Data, fileName: String) async throws
    func deleteImage(fileName: String) async throws
    func fetchCategoryPhotos(for category: String) async throws -> [String]
}
