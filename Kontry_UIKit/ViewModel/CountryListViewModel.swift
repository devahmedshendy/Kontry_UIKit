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
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    
    init() {
        updateCountryList()
    }
    
    //MARK: - STATES with GETTERS
    
    @Published
    private(set) var countryList: [Country] = []
    
    //MARK: - MUTATIONS
    
    func EMIT_COUNTRY_LIST(_ list: [Country]) {
        countryList = list
    }
        
    //MARK: - ACTIONS
    
    private func updateCountryList() {
        repository
            .fetchCountryList()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] list in
                    self?.EMIT_COUNTRY_LIST(list)
                }
            )
            .store(in: &cancellables)
    }
}
