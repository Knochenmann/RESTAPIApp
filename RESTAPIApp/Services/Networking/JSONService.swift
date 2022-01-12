//
//  JSONService.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 12.01.2022.
//

import Foundation


protocol Coder {
    func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T?
    func encode<T: Encodable>(object: T) -> Data?
}


class JSONService: Coder {
    
    func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil}
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("Failed to decode JSON Data:", error)
            return nil
        }
    }
    
    func encode<T: Encodable>(object: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            return data
        } catch let error {
            print("Failed to encode object to Data:", error)
            return nil
        }
    }
    
}

