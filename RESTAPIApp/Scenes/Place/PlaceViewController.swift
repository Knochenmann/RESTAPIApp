//
//  PlaceViewController.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import UIKit
import MapKit


class PlaceViewController: UIViewController {
    
    // MARK: - Public Properties:
    
    var place: Place!
    
    // MARK: - Private Properties:
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    // MARK: - Life Cycle Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSetup()
    }
    
    
    // MARK: - Private Methods:
    
    func mapViewSetup() {
        // Setting up an initial map position, adding a pin:
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: place.latitude,
            longitude: place.longitude
        )
        let mapPin = MapPin(
            title: place.name,
            locationName: place.name,
            coordinate: centerCoordinate
        )
        let coordinateRegion = MKCoordinateRegion(
            center: mapPin.coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotations([mapPin])
        
        // MapView Layout:
        view.addSubview(mapView)
        NSLayoutConstraint.activate(
            [
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
}
