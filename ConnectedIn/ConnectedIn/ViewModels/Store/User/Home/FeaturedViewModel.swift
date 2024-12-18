//
//  File.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import Foundation
import Combine

class FeaturedViewModel: ObservableObject {
//    @Published var featuredChurches: [TestChurch] = []
//    @Published var error: Error
    @Published var featuredMissionaries: [Missionary] = []
    @Published var featuredMinistries: [Ministry] = []
    @Published var donationBalance: String = "P200.00"
    
    func fetchData() {
//        fetchFeaturedMissionaries()
//        fetchFeaturedMinistries()
    }
//
//    
//    func fetchFeaturedChurches() {
//        
//    }
//    
//    func fetchFeaturedMissionaries() {
//        
//    }
//    
//    func fetchFeaturedMinistries() {
//        
//    }
    
//    func fetchFeaturedChurches() {
//        self.featuredChurches = [
//            TestChurch(id: 1, name: "FFBC Sorsogon", location: "Sorsogon City", imageUrl: "image1"),
//            TestChurch(id: 2, name: "Heritage Baptist Church", location: "Davao", imageUrl: "image2")
//            TestChurch(id: 3, name: "", location: "", imageUrl: "image1")
//        ]
//    }
    
    func fetchFeaturedMissionaries() {
//        self.featuredMissionaries = [
//            Missionary(id: 1, name: "John Smith", region: "Africa", imageUrl: "missionary1"),
//            Missionary(id: 2, name: "Neil Docog", region: "Thailand", imageUrl: "missionary2"),
//            Missionary(id: 3, name: "Fletch Espiel", region: "Cambodia", imageUrl: "missionary3"),
//            Missionary(id: 4, name: "Jane Doe", region: "Vietnam", imageUrl: "missionary4"),
//            Missionary(id: 5, name: "Jem Tud", region: "Davao", imageUrl: "missionary5")
//        ]
    }

//    func fetchFeaturedMinistries() {
//        self.featuredMinistries = [
//            Ministry(id: 1, name: "Youth Ministry", description: "Supporting youth across the globe", imageUrl: "ministry1"),
//            Ministry(id: 2, name: "Women’s Ministry", description: "Empowering women in faith", imageUrl: "ministry2"),
//            Ministry(id: 3, name: "CrossDrive Missions", description: "Young missionaries in Bicol", imageUrl: "ministry3"),
//            Ministry(id: 4, name: "Bicol Captures", description: "Christian community of photographers", imageUrl: "ministry4")
//        ]
//    }
}
