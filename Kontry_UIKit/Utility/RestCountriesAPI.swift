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
        case all = "all"
        case name = "name"
    }
    
    //MARK: - Static Properties
    
    private static let baseURL = "https://restcountries.eu/rest/v2"
    
    //MARK: - Helper Methods
    
    static func createAllURL() -> URL {
        return createURL(endpoint: Endpoint.all,
                         params: nil)
    }
    
    static func createNameURL(params: [String :String]) -> URL {
        return createURL(endpoint: Endpoint.name,
                         params: params)
    }
    
    private static func createURL(endpoint: Endpoint,
                                  params: [String: String]?) -> URL {
        var components = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem]()
        
        if let params = params {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}
