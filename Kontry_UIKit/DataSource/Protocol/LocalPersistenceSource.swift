//
//  LocalPersistenceSource.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/21/21.
//

import Foundation
import Combine

protocol LocalPersistenceSource {
    func findFlagEntity(for alpha2Code: String) -> AnyPublisher<FlagEntity?, Error>
    func createFlagEntity(for alpha2Code: String, _ image: Data)
    
    func findDetailsEntity(for alpha2Code: String) -> AnyPublisher<DetailsEntity?, Error>
    func createDetailsEntity(from countryDetails: CountryDetailsModel)
}
