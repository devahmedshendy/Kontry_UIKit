//
//  CountryDetailsDto.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import MapKit

struct CountryDetailsDto {
    
    //MARK: - Properties
    
    let name: String
    let alpha2Code: String
    let capital: String
    let region: String
    let population: String
    let mapRegion: MKCoordinateRegion
    let currencies: String
    let languages: String
    
}

//MARK: - Struct Custom init

extension CountryDetailsDto {
    init(from details: CountryDetailsModel) {
        name = details.name
        alpha2Code = details.alpha2Code
        capital = details.alpha2Code
        region = details.region
        population = "\(details.population) \(details.demonym)"
        
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: details.latlng[0], longitude: details.latlng[1]),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        )
        
        currencies = {
            let string = details.currencies
                .map { $0.code ?? "" }
                .joined(separator: ", ")
            
            return string.isEmpty ? Constant.UNAVAILABLE : string
        }()
        
        languages = {
            let string = details.languages
                .map { $0.name }
                .joined(separator: ", ")
            
            return string.isEmpty ? Constant.UNAVAILABLE : string
        }()
    }
}
