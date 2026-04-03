//
//  CreateClothRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation
import Firebase
import FirebaseStorage

final class CreateClothRepositoryImpl: ICreateClothRepository {
    private let userId: String
    private let db = Firestore.firestore()
    private let categoryDataSource: CategoryRemoteDataSource

    init(userId: String, categoryDataSource: CategoryRemoteDataSource = CategoryRemoteDataSource()) {
        self.userId = userId
        self.categoryDataSource = categoryDataSource
    }

    func createCloth(_ input: CreateClothInput) async throws {
        let dto = CreateClothMapper.toDTO(input)
        let data = CreateClothMapper.toFirestore(dto)
        try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .document(input.id)
            .setData(data)
    }

    func updateCloth(_ input: CreateClothInput) async throws {
        let dto = CreateClothMapper.toDTO(input)
        let data = CreateClothMapper.toFirestore(dto)
        try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .document(input.id)
            .setData(data)
    }

    func uploadImage(data: Data, fileName: String) async throws {
        let ref = Storage.storage().reference(withPath: fileName)
        _ = try await ref.putDataAsync(data)
    }

    func deleteImage(fileName: String) async throws {
        let ref = Storage.storage().reference().child(fileName)
        try await ref.delete()
    }

    func fetchCategoryPhotos(for category: String) async throws -> [String] {
        try await categoryDataSource.fetchPhotos(for: category)
    }
}
