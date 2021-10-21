//
//  CountryDetailsViewModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import Foundation
import Combine

// Responsibility:
// A viewmodel that handles data/state required by the views from CountryDetailsViewController.
final class CountryDetailsViewModel {
    
    //MARK: - Properties
    
    private lazy var repository: Repository = Repository()
    
    //MARK: - STATES with GETTERS
    
    //MARK: - MUTATIONS
    
    //MARK: - ACTIONS
    
    func loadCountryDetails(of code: String) -> AnyPublisher<CountryDetails?, Error> {
        return repository
            .getCountryDetails(for: code)
            .eraseToAnyPublisher()
    }
}
