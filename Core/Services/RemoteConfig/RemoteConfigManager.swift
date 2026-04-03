//
//  RemoteConfigManager.swift
//  Clowy
//
//  Created by Egor Karpukhin on 30/12/2023.
//

import FirebaseRemoteConfig
import Foundation

final class RemoteConfigManager {

    static let shared = RemoteConfigManager()

    private let remoteConfig: RemoteConfig

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
    }

    // MARK: - Configure

    func configure() async {
        do {
            let status = try await remoteConfig.fetch()
            if status == .success {
                try await remoteConfig.activate()
            }
        } catch {
            AppLogger.log("RemoteConfig fetch failed: \(error.localizedDescription)", category: .network)
        }
    }

    // MARK: - Accessors

    func stringValue(forKey key: String) -> String {
        remoteConfig.configValue(forKey: key).stringValue ?? ""
    }

    func dataValue(forKey key: String) -> Data {
        remoteConfig.configValue(forKey: key).dataValue
    }
}
