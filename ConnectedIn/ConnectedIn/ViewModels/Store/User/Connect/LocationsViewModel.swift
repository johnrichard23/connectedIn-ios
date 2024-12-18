//
//  LocationViewModel.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 8/3/24.
//

import Foundation
import MapKit
import SwiftUI
import Combine

final class LocationsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var churches: [Church] = []
    @Published var mapChurch: Church?
    @Published var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    @Published var locations: [TestLocation] = []
    @Published var showChurchesList: Bool = false
    @Published var sheetChurch: Church? = nil
    @Published var userLocation: CLLocation?
    @Published var nearestChurch: Church?
    @Published var isLoading = false
    @Published var error: Error?
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    
    private let locationManager = CLLocationManager()
    private let churchService: ChurchServiceProtocol
    private let mockChurchService: MockChurchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    

    init(churchService: ChurchServiceProtocol = ChurchService(), mockService: MockChurchServiceProtocol = MockChurchService()) {
        self.churchService = churchService
        self.mockChurchService = mockService
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
//    func fetchChurches() {
//        isLoading = true
//        error = nil
//        
//        churchService.fetchChurches()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                if case .failure(let error) = completion {
//                    self?.error = error
//                }
//            } receiveValue: { [weak self] churches in
//                self?.churches = churches
//                self?.mapChurch = churches.first
//                if let firstChurch = churches.first {
//                    self?.updateMapPosition(coordinate: <#T##CLLocationCoordinate2D#>)
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    func toggleChurchesList() {
        withAnimation(.easeInOut) {
            showChurchesList.toggle()
        }
    }
    
    func showNextChurch(church: Church) {
        mapChurch = church
        mapPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: church.latitude, longitude: church.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    func nextButtonPressed() {
        guard let currentIndex = churches.firstIndex(where: { $0.id == mapChurch?.id }) else {
            print("Could not find current index in churches array! Should never happen.")
            return
        }
        
        let nextIndex = currentIndex + 1
        guard churches.indices.contains(nextIndex) else {
            guard let firstChurch = churches.first else { return }
            showNextChurch(church: firstChurch)
            return
        }
        
        let nextChurch = churches[nextIndex]
        showNextChurch(church: nextChurch)
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location  // Store the entire CLLocation object
        updateMapPosition(coordinate: location.coordinate)
//        fetchNearbyChurches(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    private func updateMapPosition(coordinate: CLLocationCoordinate2D) {
        mapPosition = .region(MKCoordinateRegion(
            center: coordinate,
            span: mapSpan
        ))
    }
    
//    private func fetchNearbyChurches(latitude: Double, longitude: Double) {
//        mockChurchService.fetchNearbyChurches(latitude: latitude, longitude: longitude) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let churches):
//                    self?.churches = churches
//                case .failure(let error):
//                    print("Error fetching nearby churches: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
    func selectChurch(_ church: Church) {
        mapChurch = church
        updateMapPosition(coordinate: CLLocationCoordinate2D(latitude: church.latitude, longitude: church.longitude))
    }
    
    func findNearestChurch() {
        guard let userLocation = userLocation else { return }
        
        nearestChurch = churches.min { church1, church2 in
            let distance1 = userLocation.distance(from: CLLocation(latitude: church1.latitude, longitude: church1.longitude))
            let distance2 = userLocation.distance(from: CLLocation(latitude: church2.latitude, longitude: church2.longitude))
            return distance1 < distance2
        }
    }
}
