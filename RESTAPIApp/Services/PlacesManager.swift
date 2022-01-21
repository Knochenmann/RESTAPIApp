//
//  PlacesManager.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 12.01.2022.
//

import Foundation


protocol PlacesProtocol {
    func fetchPlaces(completion: @escaping ([Place]?) -> Void)
    func removePlace(_ place: Place, completion: @escaping (_ error: Error?) -> Void)
    func pushPlace(_ place: Place, completion: @escaping (Place?) -> Void)
    func editPlace(_ place: Place, completion: @escaping (Place?) -> Void)
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
    
    func pushPlace(_ place: Place, completion: @escaping (Place?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Knochenmann/demo/places"
        networkManager.push(object: place, to: urlString, response: completion)
    }
    
    func removePlace(_ place: Place, completion: @escaping (_ error: Error?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Knochenmann/demo/places/\(place.id)"
        networkManager.delete(from: urlString, response: completion)
    }
    
    func editPlace(_ place: Place, completion: @escaping (Place?) -> Void) {
        let urlString = "https://my-json-server.typicode.com/Knochenmann/demo/places/\(place.id)"
        networkManager.put(object: place, to: urlString, response: completion)
    }
}
