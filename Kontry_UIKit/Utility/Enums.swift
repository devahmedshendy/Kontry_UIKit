//
//  Enums.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/13/21.
//

import Foundation

enum Section: CaseIterable {
    case main
}

enum CountriesApiQueryField: String {
    case all = "all"
    case name = "name"
    case alpha2Code = "alpha"
}

enum FlagSize {
    case w20
    case w40
    case w160
    case w320
    case w640
}

