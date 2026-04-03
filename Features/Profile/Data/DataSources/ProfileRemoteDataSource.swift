//
//  ProfileRemoteDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Firebase

final class ProfileRemoteDataSource {
    private let userId: String
    private let db = Firestore.firestore()

    init(userId: String) {
        self.userId = userId
    }

    func fetchUser() async throws -> UserDTO {
        let document = try await db
            .collection("Users")
            .document(userId)
            .getDocument()

        guard let data = document.data() else {
            throw ProfileError.userNotFound
        }

        return UserDTO(
            id: document.documentID,
            username: data["username"] as? String ?? "",
            userIcon: data["userIcon"] as? String ?? "",
            config: data["config"] as? String ?? "",
            didOnboarding: data["didOnboarding"] as? Bool ?? false,
            preferedStyle: data["preferedStyle"] as? String ?? "",
            hatTemperature: data["hatTemperature"] as? String ?? "",
            isTshirtUnder: data["isTshirtUnder"] as? Bool ?? true,
            excludedClothes: data["excludedClothes"] as? [String] ?? [],
            skirtPairings: data["skirtPairings"] as? [String] ?? [],
            skirtWeather: data["skirtWeather"] as? [String] ?? [],
            dressPairings: data["dressPairings"] as? [String] ?? [],
            dressWeather: data["dressWeather"] as? [String] ?? []
        )
    }

    func updateUser(_ dto: UserDTO) async throws {
        try await db
            .collection("Users")
            .document(userId)
            .setData([
                "username": dto.username,
                "userIcon": dto.userIcon,
                "config": dto.config,
                "didOnboarding": dto.didOnboarding,
                "preferedStyle": dto.preferedStyle,
                "hatTemperature": dto.hatTemperature,
                "isTshirtUnder": dto.isTshirtUnder,
                "excludedClothes": dto.excludedClothes,
                "skirtPairings": dto.skirtPairings,
                "skirtWeather": dto.skirtWeather,
                "dressPairings": dto.dressPairings,
                "dressWeather": dto.dressWeather
            ])
    }
}

enum ProfileError: Error {
    case userNotFound
    case updateFailed
}
