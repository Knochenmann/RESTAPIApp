//
//  MapPin.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
}
