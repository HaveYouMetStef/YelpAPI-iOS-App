//
//  NetworkController.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/13/23.
//

import UIKit


class NetworkManager {
    
    let baseURL = URL(string: "https://api.yelp.com/v3")
    static let shared = NetworkManager()
    func newFetchBusiness() async throws -> YelpData {
        
        guard var url = baseURL else {
            throw NetworkError.badBaseURL
        }
        
        url.appendPathComponent("businesses")
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "term", value: "pizza"),
            URLQueryItem(name: "location", value: "1713 E Riverside Dr, Austin, TX 78741"),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        guard let builtURL = components?.url else {
            throw NetworkError.badBuiltURL
        }
        var request = URLRequest(url: builtURL)
        
        request.allHTTPHeaderFields = Constants.headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let yelpData = try JSONDecoder().decode(YelpData.self, from: data)
        
        return yelpData
    }
    
    func fetchBusiness(type: String, completion: @escaping (Result<YelpData, NetworkError>) -> Void) {
        //1 - URL
        guard var url = baseURL else { return completion(.failure(.badBaseURL))
        }
        
        url.appendPathComponent("businesses")
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
        URLQueryItem(name: "term", value: type),
        URLQueryItem(name: "location", value: "1713 E Riverside Dr, Austin, TX 78741"),
        URLQueryItem(name: "limit", value: "10"),
        ]
//        print(baseURL)
        
        guard let builtURL = components?.url else { return completion(.failure(.badBuiltURL))
        }
        
        // Request URL
        var request = URLRequest(url: builtURL)
        
        // Request Header(s)
        request.allHTTPHeaderFields = Constants.headers
        
        //2 - Data Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            //3 - Error Handling
            if let error = error {
                completion(.failure(.invalidData(error.localizedDescription)))
                print("error: \(error): \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidData(response.debugDescription)))
                return
            }
            
            //4 - Check for data
            guard let data = data else {
                print("error: \(String(describing: error)): \(error?.localizedDescription ?? "")")
                completion(.failure(.invalidData("Invalid Data")))
                return
            }
            //5 - Decode Data
            
            do {
                let business = try
                JSONDecoder().decode(YelpData.self, from: data)
                completion(.success(business))
                return
            } catch {
                print("error: \(error): \(error.localizedDescription)")
                completion(.failure(.invalidData(error.localizedDescription)))
                return
            }
        }.resume()
    }
}
