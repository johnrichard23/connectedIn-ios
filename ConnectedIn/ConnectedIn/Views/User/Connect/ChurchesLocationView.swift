 //
//  LocationsView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 8/3/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ChurchesLocationView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: LocationsViewModel
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var hasSetInitialPosition = false
    @State private var selectedChurch: Church?
    @State private var route: MKRoute?
    @State private var distanceToChurch: CLLocationDistance?
    @State private var showingDetail = false
    @State private var isNavigating = false
    @State private var isHybridMap = false
    let churches: [Church]
    
    var body: some View {
        ZStack {
            // Map View
            Map(initialPosition: position) {
                
                // User location with heading
                UserAnnotation()
                
                // Church annotations
                ForEach(churches) { church in
                    let coordinate = CLLocationCoordinate2D(
                        latitude: church.latitude,
                        longitude: church.longitude
                    )
                    Annotation("", coordinate: coordinate) {
                        // Custom Google Maps style marker
                        ZStack {
                            // Shadow
                            Circle()
                                .fill(Color.black.opacity(0.2))
                                .frame(width: 44, height: 44)
                                .offset(y: 2)
                            
                            // Marker
                            VStack(spacing: 0) {
                                // Icon container
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                                    .overlay {
                                        Image(systemName: "building.2")
                                            .font(.system(size: 20))
                                            .foregroundColor(.connectedInMain)
                                    }
                                
                                // Bottom pointer
                                Image(systemName: "triangle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .offset(y: -6)
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                            }
                        }
                        .onTapGesture {
                            selectedChurch = church
                            calculateRoute(to: church)
                            showingDetail = true
                        }
                    }
                }
                
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(isNavigating ? .blue : .gray,
                               style: StrokeStyle(
                                lineWidth: isNavigating ? 6 : 4,
                                lineCap: .round,
                                lineJoin: .round
                               ))
                }
            }
            .mapStyle(isHybridMap ? .hybrid(elevation: .realistic) : .standard(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .ignoresSafeArea()
            .overlay(alignment: .topTrailing) {
                Button {
                    isHybridMap.toggle()
                } label: {
                    Image(systemName: isHybridMap ? "map.fill" : "map")
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                }
                .padding()
            }
            
            // Navigation overlay
            if isNavigating {
                VStack {
                    if let distance = distanceToChurch {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(formatDistance(distance))
                                    .font(.title2.bold())
                                Text("remaining")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingDetail) {
            BottomSheetView(
                church: selectedChurch,
                distance: distanceToChurch,
                isNavigating: $isNavigating,
                onDismiss: {
                    withAnimation {
                        if !isNavigating {
                            route = nil
                            selectedChurch = nil
                            distanceToChurch = nil
                        }
                        showingDetail = false
                    }
                }
            )
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Helper Methods
    private func calculateRoute(to church: Church) {
        guard let userLocation = viewModel.userLocation else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(
            coordinate: userLocation.coordinate
        ))
        request.destination = MKMapItem(placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: church.latitude,
                longitude: church.longitude
            )
        ))
        
        Task {
            do {
                let directions = MKDirections(request: request)
                let response = try await directions.calculate()
                
                await MainActor.run {
                    withAnimation {
                        if let primaryRoute = response.routes.first {
                            route = primaryRoute
                            distanceToChurch = primaryRoute.distance
                            position = .rect(primaryRoute.polyline.boundingMapRect)
                        }
                    }
                }
            } catch {
                print("Error calculating route: \(error)")
            }
        }
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter.string(fromDistance: distance)
    }
    
    private func setupInitialPosition() {
        guard !hasSetInitialPosition, let location = viewModel.userLocation else { return }
        position = .camera(MapCamera(
            centerCoordinate: location.coordinate,
            distance: 1000,
            heading: 0,
            pitch: 60
        ))
        hasSetInitialPosition = true
    }
}

// MARK: - Bottom Sheet View
private struct BottomSheetView: View {
    let church: Church?
    let distance: CLLocationDistance?
    @Binding var isNavigating: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Church Info Section
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(church?.name ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if let distance = distance {
                            Label(formatDistance(distance), systemImage: "location.fill")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 12)
                
                Divider()
                
                // Details
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(icon: "clock.fill", title: "Service Times", detail: (church?.serviceTimes ?? []).joined(separator: ", "))
                    InfoRow(icon: "phone.fill", title: "Contact", detail: church?.phone ?? "Not available")
                    InfoRow(icon: "map.fill", title: "Address", detail: church?.address ?? "Not available")
                }
            }
            
            // Navigation Button
            Button {
                isNavigating.toggle()
            } label: {
                HStack {
                    Image(systemName: isNavigating ? "location.fill" : "location")
                    Text(isNavigating ? "Stop Navigation" : "Start Navigation")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isNavigating ? Color.red : Color.connectedInMain)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter.string(fromDistance: distance)
    }
}

// MARK: - Supporting Views
private struct InfoRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(detail)
                    .font(.subheadline)
            }
        }
    }
}
