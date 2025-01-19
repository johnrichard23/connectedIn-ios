//
//  LocationDetailView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 8/3/24.
//

import SwiftUI
import MapKit

struct ChurchesLocationDetailView: View {
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    let church: Church
    
    @State private var region: MKCoordinateRegion
    
    init(church: Church) {
        self.church = church
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: church.latitude, longitude: church.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

//struct LocationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationDetailView(location: LocationsService.locations.first!)
//            .environmentObject(LocationsViewModel())
//    }
//}


extension ChurchesLocationDetailView {
    
    private var imageSection: some View {
        TabView {
            ForEach(church.photos, id: \.self) { photoUrl in
                if let url = URL(string: photoUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(church.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(church.address)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(church.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let url = URL(string: church.id) {
                Link("More Details in Facebook", destination: url)
                    .font(.headline)
                    .tint(.purple)
            }
        }
    }
    
    private var mapLayer: some View {
            Map(coordinateRegion: $region, annotationItems: [church]) { church in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: church.latitude, longitude: church.longitude)) {
                    ChurchesMapAnnotationView()
                        .shadow(radius: 10)
                }
            }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
        }
    
    private var backButton: some View {
        Button {
            viewModel.sheetChurch = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.black)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}

