//
//  CountryModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

// Responsibility:
// A data model represents data to be displayed in CountryListViewController.
final class Country: Codable {
    
    //MARK: - Static Properties
    
    static var fields: String {
        return Country.CodingKeys.allCases
            .map { $0.rawValue }
            .joined(separator: ",")
    }
    
    //MARK: - Properties
    
    let name: String
    let alpha2Code: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case alpha2Code
    }
    
    //MARK: - init Methods
    
    init(name: String, alpha2Code: String) {
        self.name = name
        self.alpha2Code = alpha2Code
    }
}

extension Country: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(alpha2Code)
    }
    
    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name && lhs.alpha2Code == rhs.alpha2Code
    }
}
