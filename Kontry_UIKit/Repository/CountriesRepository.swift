//
//  CountriesRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

final class CountriesRepository: CountriesRepositoryProtocol {
    
    //MARK: - Properties
    
    private lazy var jsonDecoder = JSONDecoder()
    private let countriesApiService: CountriesApiServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    //MARK: - init Methods
    
    init(
        countriesApiService: CountriesApiServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.countriesApiService = countriesApiService
        self.persistenceService = persistenceService
    }
    
    //MARK: - Data Operations
    
    // Get list of countries from RestCountries API.
    // It restrict requested fields to the fields of Country data mdoel.
    func getCountryList() -> AnyPublisher<[CountryModel], KontryError> {
        
        return countriesApiService
            .getAll(params: [ "fields": CountryModel.fields])
            .decode(type: [CountryModel].self, decoder: jsonDecoder)
            .mapError { error -> KontryError in
                switch error {
                case is URLError:
                    return .network(description: error.localizedDescription)
                    
                case is DecodingError:
                    return .decoding(description: error.localizedDescription)
                    
                default:
                    return error as? KontryError ?? .unknown(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getCountryListByName(_ search: String) -> AnyPublisher<[CountryModel], KontryError> {
        
        return countriesApiService
            .getAllByName(search: search, params: [ "fields": CountryModel.fields])
            .flatMap { [weak self] data -> AnyPublisher<[CountryModel], Error> in
                guard let self = self, let data = data else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: [CountryModel].self, decoder: self.jsonDecoder)
                    .tryCatch { error -> AnyPublisher<[CountryModel], Error> in
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                            if let status = json["status"] as? Int, status == 404 {
                                    return Just([])
                                        .setFailureType(to: Error.self)
                                        .eraseToAnyPublisher()
                            }
                        }
                        
                        throw error
                    }
                    .eraseToAnyPublisher()
            }
            .mapError { error -> KontryError in
                switch error {
                case is URLError:
                    return .network(description: error.localizedDescription)
                    
                case is DecodingError:
                    return .decoding(description: error.localizedDescription)
                    
                default:
                    return error as? KontryError ?? .unknown(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Get more country details using alpha2Code from CoreData or RestCounties API.
    //
    // These country details are required to be saved in coredata for future requests.
    // It first checks if it is already in coredata then return it,
    //   otherwise request it from the API, then save it in coredata.
    func getCountryDetails(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, KontryError> {
        
        return findCountryDetailsLocally(for: alpha2Code)
            // Here we check if no details found locally, then get it from remote api
            // Otherwise, just pass the found details to downstream
            .flatMap { [weak self] countryDetails -> AnyPublisher<CountryDetailsModel?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
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
                            self.persistenceService.createDetailsEntity(from: countryDetails)
                        }
                        
                        return countryDetails
                    }
                    .eraseToAnyPublisher()
            }
            .mapError{ error -> KontryError in
                switch error {
                case is URLError:
                    return .network(description: error.localizedDescription)

                case is CoreDataError:
                    return .coredata(description: error.localizedDescription)

                case is DecodingError:
                    return .decoding(description: error.localizedDescription)

                default:
                    return error as? KontryError ?? .unknown(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Get country details using alpha2Code from CoreData.
    private func findCountryDetailsLocally(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, Error> {
        
        return persistenceService
            .findDetailsEntity(for: alpha2Code)
            .map { details -> CountryDetailsModel? in
                guard let details = details else { return nil }
                
                return CountryDetailsModel(from: details)
            }
            .eraseToAnyPublisher()
    }
    
    // Get country details using alpha2Code from RestCountries API.
    // It restrict requested fields to the fields of CountryDetails data mdoel.
    private func findCountryDetailsRemotely(for alpha2Code: String) -> AnyPublisher<CountryDetailsModel?, Error> {
        
        return countriesApiService
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
