//
//  RestCountriesSource.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/23/21.
//

import Foundation
import Combine

// Responsibility:
// It handles network-related tasks for RestCountries API.
// It uses URLSession for this.
final class RestCountriesSource: RemoteCountriesSource {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    //MARK: - API Calls
    
    func getAll(params: [String : String]) -> AnyPublisher<Data, Error> {
        let url = ApiUtility.createURL(pathParam: .all,
                                       queryParams: params)
        
        return defaultSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getAllByName(search: String, params: [String : String]) -> AnyPublisher<Data?, Error> {
        let url = ApiUtility.createURL(pathParam: .name,
                                       pathValue: search,
                                       queryParams: params)
        
        return defaultSession
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
    
    func getOne(by field: CountriesApiQueryField,
                fieldValue: String,
                params: [String : String]) -> AnyPublisher<Data?, Error> {
        let url = ApiUtility.createURL(pathParam: field,
                                       pathValue: fieldValue,
                                       queryParams: params)

        return defaultSession
            .dataTaskPublisher(for: url)
            .map { result -> Data? in
                let response = result.response as! HTTPURLResponse
                let statusCode = response.statusCode
                
                if statusCode == 404 {
                    return nil
                }
                
                return result.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

//MARK: - API Utility

extension RestCountriesSource {
    
    // Responsibility:
    // It encapsulates info related to RestCountries API (ex: baseURL, endpoints).
    // It helps create URL objects to use to communicate with the API.
    private struct ApiUtility {
                
    //    private static let baseURL = "https://restcountries.eu/rest/v2" // It is down
        private static let baseURL = "https://restcountries.com/v2"
                
        static func createURL(pathParam: CountriesApiQueryField,
                              pathValue: String = "",
                              queryParams: [String:String] = [:]) -> URL {
            
            var components = URLComponents(string: baseURL)!
            components.path += "/" + pathParam.rawValue
            components.path += pathValue.isEmpty ? "" : "/" + pathValue
            
            var queryItems = [URLQueryItem]()
            
            for (key, value) in queryParams {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
            
            components.queryItems = queryItems
            
            return components.url!
        }
    }
    
}
