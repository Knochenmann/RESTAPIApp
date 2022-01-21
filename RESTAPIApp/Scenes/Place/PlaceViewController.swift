//
//  PlaceViewController.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import UIKit
import MapKit


class PlaceViewController: UIViewController {
    
    // MARK: - Private Properties:
    
    private var place: Place?
    private var callback: ((_ editedPlace: Place?) -> Void)?
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let placeNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let placeNameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    private let changePlaceNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.orange.cgColor
        return button
    }()
    
    // MARK: - Initializers:
    
    init(place: Place?, closure: ((_ editedPlace: Place?) -> Void)?) {
        self.place = place
        self.callback = closure
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSetup()
        placeNameViewSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        placeNameView.layer.cornerRadius = 6
        changePlaceNameButton.layer.cornerRadius = 4
    }
    
    
    // MARK: - Private Methods:
    
    private func mapViewSetup() {
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
        
        // Setting up an initial map position, adding a pin:
        setMapPin()
    }
    
    private func setMapPin() {
        guard let place = place else {
            return
        }
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
        
    }
    
    private func placeNameViewSetup() {
        // placeNameView Layout:
        view.addSubview(placeNameView)
        NSLayoutConstraint.activate(
            [
                placeNameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
                placeNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                placeNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                placeNameView.heightAnchor.constraint(equalToConstant: 40)
            ]
        )
        
        // Adding a text field on the view:
        placeNameView.addSubview(placeNameTextField)
        placeNameTextField.text = place?.name
        placeNameTextField.placeholder = "Укажите название места"
        NSLayoutConstraint.activate(
            [
                placeNameTextField.topAnchor.constraint(equalTo: placeNameView.topAnchor, constant: 4),
                placeNameTextField.leadingAnchor.constraint(equalTo: placeNameView.leadingAnchor, constant: 4),
                placeNameTextField.widthAnchor.constraint(equalTo: placeNameView.widthAnchor, multiplier: 0.6),
                placeNameTextField.bottomAnchor.constraint(equalTo: placeNameView.bottomAnchor, constant: -4)
            ]
        )
        
        // Adding a button:
        placeNameView.addSubview(changePlaceNameButton)
        changePlaceNameButton.setTitle("Изменить", for: .normal)
        changePlaceNameButton.addTarget(self, action: #selector(changePlaceName), for: .touchUpInside)
        NSLayoutConstraint.activate(
            [
                changePlaceNameButton.topAnchor.constraint(equalTo: placeNameView.topAnchor, constant: 4),
                changePlaceNameButton.leadingAnchor.constraint(equalTo: placeNameTextField.trailingAnchor, constant: 8),
                changePlaceNameButton.trailingAnchor.constraint(equalTo: placeNameView.trailingAnchor, constant: -4),
                changePlaceNameButton.bottomAnchor.constraint(equalTo: placeNameView.bottomAnchor, constant: -4)
            ]
        )
    }
    
    @objc private func changePlaceName() {
        guard let text = placeNameTextField.text, text != "" else { return }
        if let place = place {
//            place.name = text
            callback!(place)
        }
    }
    
    deinit {
        print("PlaceViewController has been dealocated.")
    }
}
