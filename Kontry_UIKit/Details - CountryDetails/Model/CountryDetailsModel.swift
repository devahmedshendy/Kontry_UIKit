//
//  CountryDetail.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation
import MapKit

// Responsibility:
// A data model represents data to be displayed in CountryDetailsViewController.
struct CountryDetailsModel: Codable {
    
    //MARK: - Types
    
    struct Currency: Codable {
        let code: String?
    }
    
    struct Language: Codable {
        let name: String
    }
    
    //MARK: - Static Properties
    
    static var fields: String {
        return CountryDetailsModel.CodingKeys.allCases
            .map { $0.rawValue }
            .joined(separator: ",")
    }
    
    //MARK: - Properties
    
    let name: String
    let alpha2Code: String
    var capital: String
    let region: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let currencies: [Currency]
    let languages: [Language]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case alpha2Code
        case capital
        case region
        case population
        case latlng
        case demonym
        case currencies
        case languages
    }
    
    //MARK: - init Methods
    
    // It was best to decode manually so I can decide early and clearly what
    // to do for unexpected fields (ex: country with no coordinates or no capital).
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        alpha2Code = try container.decode(String.self, forKey: .alpha2Code)
        capital = try {
            let value = try container.decode(String.self, forKey: .capital)
            return value.isEmpty ? Constant.UNAVAILABLE : value
        }()
        region = try container.decode(String.self, forKey: .region)
        population = try container.decode(Int.self, forKey: .population)
        latlng = try {
            let value = try container.decode([Double].self, forKey: .latlng)
            return value.isEmpty ? [0, 0] : value
        }()
        demonym = try container.decode(String.self, forKey: .demonym)
        currencies = try container.decodeIfPresent([Currency].self, forKey: .currencies) ?? []
        languages = try container.decodeIfPresent([Language].self, forKey: .languages) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(alpha2Code, forKey: .alpha2Code)
        try container.encode(capital, forKey: .capital)
        try container.encode(region, forKey: .region)
        try container.encode(population, forKey: .population)
        try container.encode(latlng, forKey: .latlng)
        try container.encode(demonym, forKey: .demonym)
        try container.encode(currencies, forKey: .currencies)
        try container.encode(languages, forKey: .languages)
    }
}

extension CountryDetailsModel: Equatable {
    static func ==(lhs: CountryDetailsModel, rhs: CountryDetailsModel) -> Bool {
        return lhs.name == rhs.name
    }
}

//MARK: - Initialize From Different Models/Componenets

extension CountryDetailsModel {
    init(from detailsEntity: DetailsEntity) {
        name = detailsEntity.name!
        alpha2Code = detailsEntity.alpha2_code!
        capital = detailsEntity.capital!
        region = detailsEntity.region!
        population = Int(detailsEntity.population)
        latlng = [detailsEntity.latitude, detailsEntity.longitude]
        demonym = detailsEntity.demonym!
        currencies = detailsEntity.currencies?.toArray(of: CurrencyEntity.self).map { Currency(code: $0.code) } ?? []
        languages = detailsEntity.languages?.toArray(of: LanguageEntity.self).map { Language(name: $0.name!) } ?? []
    }
}
