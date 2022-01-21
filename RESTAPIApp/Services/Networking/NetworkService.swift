//
//  NetworkService.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 10.01.2022.
//

import Foundation


protocol Networking {
    func makeGetRequest(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
    func makePostRequest(with data: Data, urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
    func makeDeleteRequest(urlString: String, completion: @escaping (_ error: Error?) -> Void)
    func makePutRequest(with data: Data, urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
}


class NetworkService: Networking {
    
    func makeGetRequest(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func makePostRequest(with data: Data, urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func makeDeleteRequest(urlString: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = createDataTask(from: request) { _, error in
            completion(error)
        }
        task.resume()
    }
    
    func makePutRequest(with data: Data, urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("HTTP Status Code: \(response.statusCode)")
            }
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
