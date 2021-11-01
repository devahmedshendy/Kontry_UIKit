//
//  CountriesRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

protocol CountriesRepository {
    
    func getCountryList() -> AnyPublisher<[CountryModel], KontryError>
    func getCountryListByName(_ search: String) -> AnyPublisher<[CountryModel], KontryError>
    func getCountryDetails(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, KontryError>
    
}
