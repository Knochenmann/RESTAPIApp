//
//  PlacesManager.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 12.01.2022.
//

import Foundation


protocol PlacesProtocol {
    func fetchPlaces(completion: @escaping ([Place]?) -> Void)
    func push(place: Place, completion: @escaping (Place?) -> Void)
}

class PlacesManager: PlacesProtocol {
    
    private var networkManager: NetworkManager
    
    
    init(networkManager: NetworkManager = NetworkDataService()) {
        self.networkManager = networkManager
    }
    
    
    func fetchPlaces(completion: @escaping ([Place]?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Knochenmann/demo/places"
        networkManager.fetchData(from: urlString, response: completion)
    }
    
    func push(place: Place, completion: @escaping (Place?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Knochenmann/demo/places"
        networkManager.push(object: place, to: urlString, response: completion)
    }
    
}
