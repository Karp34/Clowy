//
//  OutfitRemoteDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import Foundation
import Firebase

final class OutfitRemoteDataSource {
    private let userId: String
    private let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
    }

    func fetchOutfits() async throws -> [OutfitDTO] {
        let snapshot = try await db
            .collection("Users")
            .document(userId)
            .collection("Outfits")
            .getDocuments()

        return snapshot.documents.map { document in
            let data = document.data()
            return OutfitDTO(
                id: document.documentID,
                name: data["name"] as? String ?? "No name",
                isGenerated: data["isGenerated"] as? Bool ?? false,
                clothes: data["clothes"] as? [String] ?? [],
                createDTM: data["createDTM"] as? Double ?? 0
            )
        }
    }

    func createOutfit(clothes: [String], name: String, isGenerated: Bool) async throws {
        try await db
            .collection("Users")
            .document(userId)
            .collection("Outfits")
            .addDocument(data: [
                "name": name,
                "isGenerated": isGenerated,
                "clothes": clothes,
                "createDTM": Date().timeIntervalSince1970
            ])
    }
}
