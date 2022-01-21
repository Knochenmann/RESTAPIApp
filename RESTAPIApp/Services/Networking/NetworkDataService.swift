//
//  NetworkDataService.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 12.01.2022.
//

import Foundation


protocol NetworkManager {
    func fetchData<T: Decodable>(from urlString: String, response: @escaping (T?) -> Void)
    func push<T: Codable>(object: T, to urlString: String, response: @escaping (T?) -> Void)
    func delete(from urlString: String, response: @escaping (Error?) -> Void)
    func put<T: Codable>(object: T, to urlString: String, response: @escaping (T?) -> Void)
}


class NetworkDataService: NetworkManager {
    
    private var networking: Networking
    private var coder: Coder
    
    
    init(coder: Coder = JSONService(), networking: Networking = NetworkService()) {
        self.coder = coder
        self.networking = networking
    }
    
    
    func fetchData<T: Decodable>(from urlString: String, response: @escaping (T?) -> Void) {
        networking.makeGetRequest(urlString: urlString) { [unowned self] data, error in
            if let error = error {
                print("An Error has been appeared while fetching data:\n\(error)")
                response(nil)
            }
            
            // Decoding of the received data:
            let decodedData = coder.decodeJSON(type: T.self, from: data)
            response(decodedData)
        }
    }
    
    func push<T: Codable>(object: T, to urlString: String, response: @escaping (T?) -> Void) {
        // Encoding the selected object:
        guard let encodedData = coder.encode(object: object) else { return }
        
        // Pushing the encoded object to server:
        networking.makePostRequest(with: encodedData, urlString: urlString) { [unowned self] data, error in
            if let error = error {
                print("An Error has been appeared while posting data. Details:\n\(error)")
                response(nil)
            }
            
            // Decoding of the pushed data:
            let decodedObject = coder.decodeJSON(type: T.self, from: data)
            response(decodedObject)
        }
    }
    
    func put<T: Codable>(object: T, to urlString: String, response: @escaping (T?) -> Void) {
        // Encoding the selected object:
        guard let encodedData = coder.encode(object: object) else { return }
    
        networking.makePutRequest(with: encodedData, urlString: urlString) { [unowned self] data, error in
            if let error = error {
                print("An Error has been appeared while putting data. Details:\n\(error)")
                response(nil)
            }
            
            let decodedObject = coder.decodeJSON(type: T.self, from: data)
            response(decodedObject)
        }
        
    }
    
    func delete(from urlString: String, response: @escaping (Error?) -> Void) {
        networking.makeDeleteRequest(urlString: urlString, completion: response)
    }
    
}
