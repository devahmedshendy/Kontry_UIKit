//
//  Store.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation
import Combine

// Responsibility:
// A viewmodel that handles data/state required by the views from CountryListViewController.
final class CountryListViewModel {
    
    //MARK: - Properties
    
    let countriesPublisher = PassthroughSubject<[CountryDto], Never>()
    
    private(set) var countriesRepository: CountriesRepositoryProtocol
    private var subscription: AnyCancellable?
    
    let loading: VisibilityViewModelProtocol
    let retryError: VisibilityViewModelProtocol
    
    var searchText: String = ""
    
    //MARK: - init Methods
    
    init(
        countriesRepository: CountriesRepositoryProtocol,
        loadingViewModel: VisibilityViewModelProtocol,
        retryErrorViewModel: VisibilityViewModelProtocol
    ) {
        self.countriesRepository = countriesRepository
        self.loading = loadingViewModel
        self.retryError = retryErrorViewModel
    }
    
    //MARK: - Send Events Methods
    
    private func send(list: [CountryModel]) {
        countriesPublisher.send(list.map { CountryDto(from: $0) })
    }
    
    //MARK: - Actions
    
    func loadCountries()  {
        cancelPreviousSubscription()
        
        loading.show()
        
        subscription = getCountryListPublisher()
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.loading.hide()

                    if case let .failure(error) = completion {
                        self?.retryError.show()
                        print(error)
                    }
                },
                receiveValue: { [weak self] list in
                    self?.send(list: list)
                }
            )
    }
    
    func retryLoadCountries() {
        retryError.hide()
        loadCountries()
    }
    
    func clearCountryList() {
        send(list: [])
    }
    
    //MARK: - Helper Methods
    
    private func getCountryListPublisher() -> AnyPublisher<[CountryModel], KontryError> {
        return searchText.isEmpty
            ? countriesRepository.getCountryList()
            : countriesRepository.getCountryListByName(searchText)
    }
    
    private func cancelPreviousSubscription() {
        subscription?.cancel()
        subscription = nil
    }
}
