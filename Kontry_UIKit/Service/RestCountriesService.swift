//
//  RestCountriesService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/23/21.
//

import Foundation

final class RestCountriesService {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    //MARK: - Methods
    
    func getAllCountries() -> URLSession.DataTaskPublisher {
        let url = RestCountriesAPI.createAllURL()

        return defaultSession.dataTaskPublisher(for: url)
    }
    
    func getCountryFlag(_ flagURL: String) -> URLSession.DataTaskPublisher {
        let url = URL(string: flagURL)!
        
        return defaultSession.dataTaskPublisher(for: url)
    }
}
