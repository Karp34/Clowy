//
//  IdentifiableMessage.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import Foundation

struct IdentifiableMessage: Identifiable {
    let id = UUID()
    let value: String
 
    init(_ value: String) {
        self.value = value
    }
}
 
// A lightweight `Identifiable` wrapper around a plain `String`.
// Use this instead of `extension String: Identifiable` to avoidpolluting the global namespace.
//
// Usage: @Published var errorMessage: IdentifiableMessage?
// Trigger alert: errorMessage = IdentifiableMessage("Something went wrong.")

// In View:
// .alert(item: $viewModel.errorMessage) { msg in
//     Alert(title: Text("Error"), message: Text(msg.value))
// }
