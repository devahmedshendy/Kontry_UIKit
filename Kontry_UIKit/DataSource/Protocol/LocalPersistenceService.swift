//
//  PersistenceServiceProtocol.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/21/21.
//

import Foundation
import Combine

protocol PersistenceServiceProtocol {
    func findFlagEntity(for alpha2Code: String) -> AnyPublisher<FlagEntity?, CoreDataError>
    func createFlagEntity(for alpha2Code: String, image: Data)
    
    func findDetailsEntity(for alpha2Code: String) -> AnyPublisher<DetailsEntity?, CoreDataError>
    func createDetailsEntity(from countryDetails: CountryDetails)
}
