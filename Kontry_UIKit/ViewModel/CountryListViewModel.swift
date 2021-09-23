//
//  Store.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation
import Combine

final class CountryListViewModel {
    
    //MARK: - Properties
    
    private lazy var repository: Repository = {
       return Repository()
    }()
    
    //MARK: - STATES/GETTERS
    
    //MARK: - MUTATIONS
        
    //MARK: - ACTIONS
    
    func loadCountries() -> AnyPublisher<[Country], RestCountriesApiError>  {
        return repository.fetchCountryList()
    }
}
