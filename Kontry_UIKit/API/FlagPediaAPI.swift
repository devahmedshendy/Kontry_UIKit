//
//  FlagPediaAPI.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import Foundation

final class FlagPediaAPI {
    
    enum Size: String {
        case w20
        case w40
        case w160
        case w320
        case w640
    }
    
    enum Error: Swift.Error {
        case notFound(error: String)
        case network(error: String)
        case unknown(error: String)
    }
    
    //MARK: - Static Properties
    
    static let baseURL = "https://flagcdn.com"
    
    //MARK: - Static Methods
    
    static func createURL(countryCode: String, size: FlagPediaAPI.Size) -> URL {
        let urlString = "\(baseURL)/\(size)/\(countryCode).png"

        return URL(string: urlString)!
    }
}
