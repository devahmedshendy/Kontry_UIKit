//
//  Enums.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/13/21.
//

import Foundation

//MARK: - Errors Enum

enum CountryFlagsError: Error {
    case flagNotFound
    case network
    case unknown
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
