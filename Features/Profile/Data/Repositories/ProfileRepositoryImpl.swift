//
//  ProfileRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Firebase

final class ProfileRepositoryImpl: IProfileRepository {
    private let remoteDataSource: ProfileRemoteDataSource

    init(remoteDataSource: ProfileRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getUserInfo() async throws -> User {
        let dto = try await remoteDataSource.fetchUser()
        return UserMapper.toDomain(dto)
    }

    func updateUser(_ user: User) async throws {
        let dto = UserMapper.toDTO(user)
        try await remoteDataSource.updateUser(dto)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
