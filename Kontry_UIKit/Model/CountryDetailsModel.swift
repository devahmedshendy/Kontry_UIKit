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
        let name: String?
        let symbol: String?
    }
    
    struct Language: Codable {
        let name: String
    }
    
    //MARK: - Properties
    
    let name: String
    let capital: String?
    let region: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let currencies: [Currency]?
    let languages: [Language]
    
    enum CodingKeys: String, CodingKey {
        case name
        case capital
        case region
        case population
        case latlng
        case demonym
        case currencies
        case languages
    }
    
    var populationAsString: String {
        return "\(population) \(demonym)"
    }
    
    var currenciesAsString: String {
        
        return currencies?
            .map { $0.code ?? "" }
            .joined(separator: ", ") ?? ""
    }
    
    var languagesAsString: String {
        
        return languages
            .map { $0.name }
            .joined(separator: ", ")
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
