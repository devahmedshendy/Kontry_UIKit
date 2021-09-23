//
//  Enums.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/13/21.
//

import Foundation

//MARK: - Error Enums

enum CountryFlagsApiError: Error {
    case flagNotFound(error: String)
    case network(error: String)
    case unknown(error: String)
}

enum RestCountriesApiError: Error {
    case network(error: String)
    case decoding(error: String)
    case unknown(error: String)
}

//MARK: - Other Enums

enum Section: CaseIterable {
    case main
}

enum FlagSize: Int {
    case size16 = 16
    case size24 = 24
    case size32 = 32
    case size48 = 48
    case size64 = 64
}
