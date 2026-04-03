//
//  AppLogger.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

enum AppLogger {
    
    enum Category: String {
        case network = "🌐 Network"
        case database = "💾 Database"
        case auth = "🔑 Auth"
        case ui = "🎨 UI"
        case general = "📋 General"
    }
    
    static func log(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("[\(category.rawValue)] [\(fileName):\(line)] \(function) → \(message)")
        #endif
    }
    
    static func error(
        _ error: Error,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("❌ [\(category.rawValue)] [\(fileName):\(line)] \(function) → \(error.localizedDescription)")
        #endif
    }
}
