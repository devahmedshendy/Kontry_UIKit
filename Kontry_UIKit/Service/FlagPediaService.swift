//
//  FlagPediaService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import Foundation

final class FlagPediaService {
    
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
    
    //MARK: - Methods
    
    func getCountryFlag(countryCode: String, size: FlagPediaAPI.Size, enableCache: Bool = false) -> URLSession.DataTaskPublisher {
        let url = FlagPediaAPI.createURL(countryCode: countryCode.lowercased(), size: size)
        let session = enableCache ? ephemeralSession : defaultSession
        
        return session.dataTaskPublisher(for: url)
    }
}
