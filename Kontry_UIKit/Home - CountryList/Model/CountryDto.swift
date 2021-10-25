//
//  CountryDto.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation

struct CountryDto {
    
    //MARK: - Properties
    
    let name: String
    let alpha2Code: String
    
}

extension CountryDto {
    init(from countryModel: CountryModel) {
        name = countryModel.name
        alpha2Code = countryModel.alpha2Code
    }
}

extension CountryDto: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(alpha2Code)
    }
    
    static func ==(lhs: CountryDto, rhs: CountryDto) -> Bool {
        return lhs.name == rhs.name && lhs.alpha2Code == rhs.alpha2Code
    }
}
