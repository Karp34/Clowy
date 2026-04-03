//
//  CategoryRemoteDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation
import Firebase

final class CategoryRemoteDataSource {
    private let db = Firestore.firestore()

    func fetchPhotos(for category: String) async throws -> [String] {
        let document = try await db
            .collection("categories")
            .document(category)
            .getDocument()

        return document.data()?["photos"] as? [String] ?? []
    }
}
