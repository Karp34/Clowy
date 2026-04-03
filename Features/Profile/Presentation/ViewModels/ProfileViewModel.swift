//
//  ProfileViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var user: User = User.empty
    @Published var location: String = UserDefaults.standard.string(forKey: "location") ?? "New York"
    @Published var state: PlaceHolderState = .placeholder

    private let repository: IProfileRepository?

    init(repository: IProfileRepository? = DIContainer.shared.profileRepository) {
        self.repository = repository
    }

    func loadUser() async {
        guard let repository else {
            AppLogger.log("ProfileViewModel: repository is nil", category: .auth)
            return
        }
        do {
            user = try await repository.getUserInfo()
            state = .success
        } catch {
            state = .error
            AppLogger.log("loadUser error: \(error)")
        }
    }

    func updateUser() async {
        guard let repository else { return }
        do {
            try await repository.updateUser(user)
        } catch {
            AppLogger.log("updateUser error: \(error)")
        }
    }

    func signOut() throws {
        try repository?.signOut()
        DIContainer.shared.reset()
    }
}
