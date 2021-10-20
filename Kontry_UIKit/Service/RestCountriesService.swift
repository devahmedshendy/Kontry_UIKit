//
//  RestCountriesService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/23/21.
//

import Foundation
import Combine

final class RestCountriesService {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    //MARK: - Methods
    
    func getAllCountries(fields: String) -> AnyPublisher<Data, URLError> {
        let url = RestCountriesAPI.createURLForAll(params: [ "fields": fields ])
        
        return defaultSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func getCountryByAlpha2Code(_ alpha2Code: String, fields: String) -> AnyPublisher<Data?, URLError> {
        let url = RestCountriesAPI.createURLForSearch(by: RestCountriesAPI.Endpoint.alphaCode,
                                                      value: alpha2Code,
                                                      params: [ "fields": fields ])

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
            .eraseToAnyPublisher()
    }
}
