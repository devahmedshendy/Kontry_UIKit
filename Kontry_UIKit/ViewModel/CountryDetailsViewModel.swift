//
//  CountryDetailsViewModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import Foundation
import Combine

final class CountryDetailsViewModel {
    
    //MARK: - Properties
    
    private lazy var repository: Repository = Repository()
    
    //MARK: - STATES with GETTERS
    
    //MARK: - MUTATIONS
    
    //MARK: - ACTIONS
    
    func loadCountryDetails(of code: String) -> AnyPublisher<CountryDetails, RestCountriesAPI.Error> {
        return repository
            .fetchCountryDetails(of: code)
            .eraseToAnyPublisher()
    }
}
