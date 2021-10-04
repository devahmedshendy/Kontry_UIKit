//
//  RestCountries_API.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

struct RestCountriesAPI {
    
    //MARK: - Endpoints
    
    enum Endpoint: String {
        case all = "/all"
        case name = "/name"
        case alpha = "/alpha"
    }
    
    enum Error: Swift.Error {
        case notFound(error: String)
        case network(error: String)
        case decoding(error: String)
        case unknown(error: String)
    }
    
    //MARK: - Static Properties
    
//    private static let baseURL = "https://restcountries.eu/rest/v2" // It is down
    private static let baseURL = "https://restcountries.com/v2"
    
    //MARK: - Helper Methods
    
    static func createAllURL() -> URL {
        return createURL(endpoint: Endpoint.all)
    }
    
    static func createSearchByAlphaURL(_ alpha: String) -> URL {
        return createURL(endpoint: Endpoint.alpha, queryPath: [alpha])
    }
    
    static func createNameURL(params: [String :String] = [:]) -> URL {
        return createURL(endpoint: Endpoint.name, params: params)
    }
    
    private static func createURL(endpoint: Endpoint,
                                  queryPath: [String] = [],
                                  params: [String: String] = [:]) -> URL {
        var components = URLComponents(string: baseURL)!
        components.path += endpoint.rawValue
        components.path += queryPath.flatMap { "/\($0)" }
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}
