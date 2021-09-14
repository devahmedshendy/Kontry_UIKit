//
//  CountryDetail.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

struct CountryDetail: Codable {
    
    //MARK: - Properties
    
    let name: String
    let capital: String
    let region: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let currencies: [Currency]
    let languages: [Language]
    let flagURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case capital
        case region
        case population
        case latlng
        case demonym
        case currencies
        case languages
        case flagURL = "flag"
    }
    
    //MARK: - Types
    
    struct Currency: Codable {
        let code: String?
        let name: String?
        let symbol: String?
    }
    
    struct Language: Codable {
        let name: String
    }
    
}

extension CountryDetail: Equatable {
    static func ==(lhs: CountryDetail, rhs: CountryDetail) -> Bool {
        return lhs.name == rhs.name
    }
}
