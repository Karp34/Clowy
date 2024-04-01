//
//  User.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 02.10.2022.
//

import SwiftUI

struct User: Codable, Identifiable {
    var id: String
    var username: String
//    var gender: String
    var userIcon: String
    var config: String
}

