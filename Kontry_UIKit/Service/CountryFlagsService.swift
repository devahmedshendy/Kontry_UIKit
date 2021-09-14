//
//  CountryFlagsService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/11/21.
//

import Foundation

final class CountryFlagsService {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: configuration)
    }()
    
    //MARK: - Methods
    
    func getCountryFlag(countryCode: String, size: FlagSize) -> URLSession.DataTaskPublisher {
        let url = CountryFlagsAPI.createURL(countryCode: countryCode, size: size)
        
        return defaultSession.dataTaskPublisher(for: url)
    }
}
