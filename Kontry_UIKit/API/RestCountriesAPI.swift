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
        case alphaCode = "/alpha"
    }
    
    //MARK: - Static Properties
    
//    private static let baseURL = "https://restcountries.eu/rest/v2" // It is down
    private static let baseURL = "https://restcountries.com/v2"
    
    //MARK: - Helper Methods
    
    static func createURLForAll(params: [String:String] = [:]) -> URL {
        return createURL(endpoint: Endpoint.all, params: params)
    }
    
    static func createURLForSearch(by endpoint: Endpoint,
                                   value: String,
                                   params: [String:String] = [:]) -> URL {
        return createURL(endpoint: endpoint, queryPath: [value], params: params)
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
