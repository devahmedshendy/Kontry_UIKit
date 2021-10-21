//
//  CountriesApiService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/21/21.
//

import Foundation
import Combine

protocol CountriesApiServiceProtocol {
    func getAll(params: [String : String]) -> AnyPublisher<Data, URLError>
    func getOne(by field: CountriesApiQueryField,
                fieldValue: String,
                params: [String : String]) -> AnyPublisher<Data?, URLError>
}

enum CountriesApiQueryField: String {
    case all = "all"
    case name = "name"
    case alpha2Code = "alpha"
}
