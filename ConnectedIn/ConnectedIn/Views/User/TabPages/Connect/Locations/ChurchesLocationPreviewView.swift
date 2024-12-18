//
//  LocationPreviewView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 8/3/24.
//

import SwiftUI
import CoreLocation

struct ChurchesLocationPreviewView: View {
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    let church: Church
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                titleSection
            }
            
            VStack(spacing: 8) {
                moreDetailsButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(10)
    }
}

//struct LocationPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.green.ignoresSafeArea()
//            
//            LocationPreviewView(location: LocationsService.locations.first!)
//                .padding()
//        }
//        .environmentObject(LocationsViewModel())
//    }
//}

extension ChurchesLocationPreviewView {
    private var imageSection: some View {
        ZStack {
            if let imageUrl = URL(string: church.avatarUrl) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(church.name)
                .font(.title2)
                .fontWeight(.bold)
            
            
            Text(church.address)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var moreDetailsButton: some View {
        Button {
            viewModel.sheetChurch = church
        } label: {
            Text("More Details")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            viewModel.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
}

