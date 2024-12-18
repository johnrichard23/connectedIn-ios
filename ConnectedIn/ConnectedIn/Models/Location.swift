//
//  Location.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 8/3/24.
//

import Foundation
import MapKit

struct TestLocation: Identifiable, Equatable {
    
    let name: String
    let locationName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    var id: String {
        name + locationName
    }
    
    //Equatable
    static func == (lhs: TestLocation, rhs: TestLocation) -> Bool {
        lhs.id == rhs.id
    }
}
