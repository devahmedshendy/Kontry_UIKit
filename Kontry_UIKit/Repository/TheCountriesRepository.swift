//
//  TheCountriesRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

// Responsibility
// It is the next component after ViewModels.
// It communicates with remote/local resources for data about countries.
final class TheCountriesRepository: CountriesRepository {
    
    //MARK: - Properties
    
    private let jsonDecoder: JSONDecoder
    private let remoteCountriesSource: RemoteCountriesSource
    private let localPersistenceSource: LocalPersistenceSource
    
    //MARK: - init Methods
    
    init(
        jsonDecoder: JSONDecoder,
        remoteCountriesSource: RemoteCountriesSource,
        localPersistenceSource: LocalPersistenceSource
    ) {
        self.jsonDecoder = jsonDecoder
        self.remoteCountriesSource = remoteCountriesSource
        self.localPersistenceSource = localPersistenceSource
    }
    
    //MARK: - Data Operations
    
    // Get list of countries from RestCountries API.
    // It requests specific fields for the result.
    func getCountryList() -> AnyPublisher<[CountryModel], KontryError> {
        
        return remoteCountriesSource
            .getAll(params: [ "fields": CountryModel.fields])
            .decode(type: [CountryModel].self, decoder: jsonDecoder)
            .mapErrorToKontryError()
    }
    
    // Get list of countries that match seach keyword from RestCountries API.
    // It requests specific fields for the result.
    func getCountryListByName(_ search: String) -> AnyPublisher<[CountryModel], KontryError> {
        
        return remoteCountriesSource
            .getAllByName(search: search, params: [ "fields": CountryModel.fields])
            .flatMap { [weak self] data -> AnyPublisher<[CountryModel], Error> in
                guard let self = self, let data = data else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: [CountryModel].self, decoder: self.jsonDecoder)
                    .tryCatch { error -> AnyPublisher<[CountryModel], DecodingError> in
                        
                        // The api is a different JSON with status 404 to say no country found for such search keyword
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                            if let status = json["status"] as? Int, status == 404 {
                                    return Just([])
                                        .setFailureType(to: DecodingError.self)
                                        .eraseToAnyPublisher()
                            }
                        }
                        
                        throw error
                    }
                    .eraseToAnyPublisher()
            }
            .mapErrorToKontryError()
    }
    
    // Get more details about specific country using alpha2Code from CoreData otherwise from RestCountries API.
    //
    // These country details are required to be saved in coredata for future requests.
    // It first checks if it is already in coredata then return it,
    //   otherwise request it from the API, then save it in coredata.
    func getCountryDetails(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, KontryError> {
        
        return findCountryDetailsLocally(for: alpha2Code)
            // Here we check if no details found locally, then get it from remote api
            // Otherwise, just pass the found details to downstream
            .flatMap { [weak self] countryDetails -> AnyPublisher<CountryDetailsModel?, Error> in
                guard let self = self else {
                    return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                }
                
                if let countryDetails = countryDetails {
                    return Just(countryDetails)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.findCountryDetailsRemotely(for: alpha2Code)
                    // Here we make sure to store details locally if we find it
                    .map { [weak self] countryDetails -> CountryDetailsModel? in
                        guard let self = self else { return countryDetails }
                        
                        if let countryDetails = countryDetails {
                            self.localPersistenceSource.createDetailsEntity(from: countryDetails)
                        }
                        
                        return countryDetails
                    }
                    .eraseToAnyPublisher()
            }
            .mapErrorToKontryError()
    }
    
    // Get country details using alpha2Code from CoreData.
    private func findCountryDetailsLocally(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, Error> {
        
        return localPersistenceSource
            .findDetailsEntity(for: alpha2Code)
            .map { details -> CountryDetailsModel? in
                guard let details = details else { return nil }
                
                return CountryDetailsModel(from: details)
            }
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // Get more details about specific country using alpha2Code from RestCountries API.
    // It requests specific fields for the result.
    private func findCountryDetailsRemotely(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, Error> {
        
        return remoteCountriesSource
            .getOne(by: .alpha2Code, fieldValue: alpha2Code, params: [ "fields": CountryDetailsModel.fields])
            .flatMap { [weak self] data -> AnyPublisher<CountryDetailsModel?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                guard let data = data else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: CountryDetailsModel.self, decoder: self.jsonDecoder)
                    .map { countryDetails -> CountryDetailsModel? in countryDetails }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
