//
//  Place.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import Foundation

class Place: Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(id: Int, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
