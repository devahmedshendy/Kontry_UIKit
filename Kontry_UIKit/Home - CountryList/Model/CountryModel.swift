//
//  CountryModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

// Responsibility:
// A data model represents basic country data requested from remote API.
struct CountryModel: Codable {
    
    //MARK: - Static Properties
    
    static var fields: String {
        return CountryModel.CodingKeys.allCases
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

//MARK: - Hashable Conformane

extension CountryModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(alpha2Code)
    }
    
    static func ==(lhs: CountryModel, rhs: CountryModel) -> Bool {
        return lhs.name == rhs.name && lhs.alpha2Code == rhs.alpha2Code
    }
}
