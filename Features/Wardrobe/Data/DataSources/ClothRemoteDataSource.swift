//
//  ClothRemoteDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation
import Firebase
import FirebaseStorage

final class ClothRemoteDataSource {
    private let userId: String
    private let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
    }

    func fetchClothes() async throws -> [ClothDTO] {
        let snapshot = try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .getDocuments()

        return snapshot.documents.map { document in
            let data = document.data()
            return ClothDTO(
                id: document.documentID,
                name: data["name"] as? String ?? "",
                type: data["type"] as? String ?? "",
                color: data["color"] as? String ?? "",
                temperature: data["temp"] as? [String] ?? [],
                isDefault: data["isDefault"] as? Bool ?? true,
                image: data["image"] as? String ?? "",
                creationDate: data["creationDate"] as? Int ?? 0
            )
        }
    }

    func deleteCloth(id: String) async throws {
        try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .document(id)
            .delete()
    }

    func deleteFromStorage(imageName: String) async throws {
        try await Storage.storage().reference().child(imageName).delete()
    }

    func getDownloadURL(for imageName: String) async throws -> URL {
        try await Storage.storage().reference().child(imageName).downloadURL()
    }
    
    func createCloth(_ input: CreateClothInput) async throws {
        try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .document(input.id)
            .setData([
                "name": input.name,
                "type": input.type,
                "image": input.image,
                "temp": input.temperature,
                "color": input.color,
                "isDefault": input.isDefault,
                "creationDate": Int(Date().timeIntervalSince1970)
            ])
    }

    func updateCloth(_ input: CreateClothInput) async throws {
        try await db
            .collection("Users")
            .document(userId)
            .collection("Wardrobe")
            .document(input.id)
            .setData([
                "name": input.name,
                "type": input.type,
                "image": input.image,
                "temp": input.temperature,
                "color": input.color,
                "isDefault": input.isDefault,
                "creationDate": Int(Date().timeIntervalSince1970)
            ])
    }
}
