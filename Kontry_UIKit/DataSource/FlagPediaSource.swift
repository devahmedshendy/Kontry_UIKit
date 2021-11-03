//
//  FlagPediaSource.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import Foundation
import Combine

// Responsibility:
// It handles network-related tasks for FlagPedia API.
// It uses URLSession for this.
final class FlagPediaSource: RemoteFlagsSource {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    private let ephemeralSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: configuration)
    }()
    
    //MARK: - API Calls
    
    func get(by field: String, size: FlagSize, enableCache: Bool) -> AnyPublisher<Data?, Error> {
        let url = ApiUtility.createURL(alpha2Code: field.lowercased(), size: size)
        let session = enableCache ? ephemeralSession : defaultSession
        
        return session
            .dataTaskPublisher(for: url)
            .tryMap { result -> Data? in
                let response = result.response as! HTTPURLResponse
                let statusCode = response.statusCode

                if statusCode == 404 {
                    throw URLError(
                        URLError.Code.badURL ,
                        userInfo: ["NSLocalizedDescriptionKey" : "Page not found for \(url)"])
                }

                return result.data
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - API Utility

extension FlagPediaSource {
    // Responsibility:
    // It encapsulates info related to RestCountries API (ex: baseURL, endpoints).
    // It helps create URL objects to use to communicate with the API.
    private struct ApiUtility {
        
        static let baseURL = "https://flagcdn.com"
        
        static func createURL(alpha2Code: String, size: FlagSize) -> URL {
            let urlString = "\(baseURL)/\(size)/\(alpha2Code).png"

            return URL(string: urlString)!
        }
    }

}
