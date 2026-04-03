//
//  SwiftUIView.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.08.2022.
//
import CoreLocation
import Combine

final class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var coordinates: CLLocationCoordinate2D?
    @Published var isLoading: Bool = false
    @Published var isDenied: Bool = false

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            isDenied = true
            AppLogger.log("Location access denied", category: .general)
        }
    }

    private func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isDenied = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = locations.first?.coordinate
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error(error, category: .general)
        isLoading = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
}
