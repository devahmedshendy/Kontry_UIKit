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
    
//    private func updateCountryList() {
//        repository
//            .fetchCountryList()
//            .sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                },
//                receiveValue: { [weak self] list in
//                    self?.EMIT_COUNTRY_LIST(list)
//                }
//            )
//            .store(in: &cancellables)
//    }
    
    func loadCountries() -> AnyPublisher<[Country], RestCountriesApiError>  {
        return repository.fetchCountryList()
    }
}
