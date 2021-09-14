//
//  CountryFlagsAPI.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/11/21.
//

import Foundation

final class CountryFlagsAPI {
    
    //MARK: - Static Properties
    
    static let baseURL = "https://www.countryflags.io"
    
    //MARK: - Static Methods
    
    static func createURL(countryCode: String, size: FlagSize, style: String = "flat") -> URL {
        return URL(string: "\(baseURL)/\(countryCode)/\(style)/\(size.rawValue).png")!
    }
    
}
