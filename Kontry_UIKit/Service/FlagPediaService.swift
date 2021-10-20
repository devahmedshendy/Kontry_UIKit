//
//  FlagPediaService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import Foundation
import Combine

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
    
    func getCountryFlag(for alpha2Code: String, size: FlagPediaAPI.Size, enableCache: Bool) -> AnyPublisher<Data?, Error> {
        let url = FlagPediaAPI.createURL(alpha2Code: alpha2Code.lowercased(), size: size)
        let session = enableCache ? ephemeralSession : defaultSession
        
        return session
            .dataTaskPublisher(for: url)
            .tryMap { result -> Data? in
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
