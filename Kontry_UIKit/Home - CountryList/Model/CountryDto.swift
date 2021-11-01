//
//  CountryDto.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation

// Responsibility:
// Its holds basic country data prepared for list of countries in CountryListViewController.
struct CountryDto {
    
    let name: String
    let alpha2Code: String
    
}

//MARK: - Struct Custom init

extension CountryDto {
    init(from countryModel: CountryModel) {
        name = countryModel.name
        alpha2Code = countryModel.alpha2Code
    }
}

//MARK: - Hashable Conformance

extension CountryDto: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(alpha2Code)
    }
    
    static func ==(lhs: CountryDto, rhs: CountryDto) -> Bool {
        return lhs.name == rhs.name && lhs.alpha2Code == rhs.alpha2Code
    }
}
