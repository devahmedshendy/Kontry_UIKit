//
//  CountryDetail.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation
import MapKit

struct CountryDetails: Codable {
    
    //MARK: - Types
    
    struct Currency: Codable {
        let code: String?
    }
    
    struct Language: Codable {
        let name: String
    }
    
    //MARK: - Static Properties
    
    static var fields: String {
        return CountryDetails.CodingKeys.allCases
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
    
    //MARK: - Computed Properties
    
    var populationAsString: String {
        return "\(population) \(demonym)"
    }
    
    var currenciesAsString: String {
        let string = currencies
            .map { $0.code ?? "" }
            .joined(separator: ", ")
        
        return string.isEmpty ? Constant.UNAVAILABLE : string
    }
    
    var languagesAsString: String {
        let string = languages
            .map { $0.name }
            .joined(separator: ", ")
        
        return string.isEmpty ? Constant.UNAVAILABLE : string
    }
    
    var mapCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
    
    var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: mapCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        )
    }
}

extension CountryDetails: Equatable {
    static func ==(lhs: CountryDetails, rhs: CountryDetails) -> Bool {
        return lhs.name == rhs.name
    }
}

extension CountryDetails {
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
