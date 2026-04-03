//
//  LocationRemoteDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class LocationRemoteDataSource {

    func searchCities(prefixName: String) async throws -> GeonamesResponse {
        let urlString = "https://secure.geonames.org/searchJSON?q=\(prefixName)&maxRows=10&username=clowy"
        guard let url = URLComponents(string: urlString)?.url else {
            throw LocationError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        var response = try decoder.decode(GeonamesResponse.self, from: data)

        var geonames = response.geonames
        geonames.sort { g1, g2 in
            let n1 = g1.name.lowercased()
            let n2 = g2.name.lowercased()
            let prefix = prefixName.lowercased()
            if n1.hasPrefix(prefix) && n2.hasPrefix(prefix) {
                return (g1.population ?? 0) > (g2.population ?? 0)
            } else if n1.hasPrefix(prefix) { return true }
            else if n2.hasPrefix(prefix) { return false }
            else { return (g1.population ?? 0) > (g2.population ?? 0) }
        }
        geonames = geonames.reduce(into: [Geoname]()) { result, geoname in
            if !result.contains(where: { $0.name == geoname.name && $0.countryCode == geoname.countryCode }) {
                result.append(geoname)
            }
        }
        response.geonames = geonames
        return response
    }
}

enum LocationError: Error {
    case invalidURL
    case noData
}
