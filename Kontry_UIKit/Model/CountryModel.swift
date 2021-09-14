//
//  CountryModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

class Country: Codable {
    
    //MARK: - Properties
    
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case code = "alpha2Code"
    }
    
}

extension Country: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
}
