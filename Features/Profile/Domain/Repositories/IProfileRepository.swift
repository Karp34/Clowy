//
//  IProfileRepository.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//
import SwiftUI

protocol IProfileRepository {
    func getUserInfo() async throws -> User
    func updateUser(_ user: User) async throws
    func signOut() throws
}
