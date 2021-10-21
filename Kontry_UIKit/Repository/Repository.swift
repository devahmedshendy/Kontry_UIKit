//
//  Repository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/22/21.
//

import Foundation
import Combine

// Responsibility:
// It communicates with services for local/remote CRUD operations on data models.
final class Repository {
    
    //MARK: - Properties
    
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var restCountriesService = RestCountriesService()
    private lazy var flagPediaService = FlagPediaService()
    private lazy var coreDataService = CoreDataService()
    
    //MARK: - Methods
    
    // Get list of countries from RestCountries API.
    // It restrict requested fields to the fields of Country data mdoel.
    func getCountryList() -> AnyPublisher<[Country], KontryError> {
        return restCountriesService
            .getAllCountries(fields: Country.fields)
            .decode(type: [Country].self, decoder: jsonDecoder)
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
    
    // Get Flag image from FlagPedia API.
    // It only request flag of width size 40px.
    func get40pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        
        return self.flagPediaService
            .getCountryFlag(for: alpha2Code, size: FlagPediaAPI.Size.w40, enableCache: true)
            .mapError { error -> KontryError in
                switch error {
                case is URLError:
                    return .network(description: error.localizedDescription)

                default:
                    return error as? KontryError ?? .unknown(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Get Flag image from CoreData or FlagPedia API.
    // It only request flag of width size 160px.
    //
    // This flag is required to be saved in coredata for future requests.
    // It first checks if it is already in coredata then return it,
    //   otherwise request it from the API, then save it in coredata.
    func get160pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        
        return coreDataService
            .findFlagEntity(for: alpha2Code)
            .mapError { $0 as Error }
            .flatMap { [weak self] flag -> AnyPublisher<Data?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if let flag = flag {
                    return Just(flag.image)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.flagPediaService
                    .getCountryFlag(for: alpha2Code, size: FlagPediaAPI.Size.w160, enableCache: false)
                    .map { image -> Data? in
                        guard let image = image else { return nil }

                        self.coreDataService.createFlagEntity(for: alpha2Code, image)

                        return image
                    }
                    .eraseToAnyPublisher()
            }
            .mapError { error -> KontryError in
                switch error {
                case is URLError:
                    return .network(description: error.localizedDescription)

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
    func getCountryDetails(for alpha2Code: String) -> AnyPublisher<CountryDetails?, Error> {
        
        return findCountryDetailsLocally(for: alpha2Code)
            // Here we check if no details found locally, then get it from remote api
            // Otherwise, just pass the found details to downstream
            .flatMap { [weak self] countryDetails -> AnyPublisher<CountryDetails?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if let countryDetails = countryDetails {
                    return Just(countryDetails)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.findCountryDetailsRemotely(for: alpha2Code)
                    // Here we make sure to store details locally if we find it
                    .map { [weak self] countryDetails -> CountryDetails? in
                        guard let self = self else { return countryDetails }
                        
                        if let countryDetails = countryDetails {
                            self.coreDataService.createDetailsEntity(from: countryDetails)
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
    
    //MARK: - Helper Methods
    
    // Get country details using alpha2Code from CoreData.
    private func findCountryDetailsLocally(for alpha2Code: String) -> AnyPublisher<CountryDetails?, Error> {
        
        return coreDataService
            .findDetailsEntity(for: alpha2Code)
            .mapError { $0 as Error }
            .map { details -> CountryDetails? in
                guard let details = details else { return nil }
                
                return CountryDetails(from: details)
            }
            .eraseToAnyPublisher()
    }
    
    // Get country details using alpha2Code from RestCountries API.
    // It restrict requested fields to the fields of CountryDetails data mdoel.
    private func findCountryDetailsRemotely(for alpha2Code: String) -> AnyPublisher<CountryDetails?, Error> {
        
        return restCountriesService
            .getCountryByAlpha2Code(alpha2Code, fields: CountryDetails.fields)
            .mapError { $0 as Error }
            .flatMap { [weak self] data -> AnyPublisher<CountryDetails?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                guard let data = data else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: CountryDetails.self, decoder: self.jsonDecoder)
                    .map { countryDetails -> CountryDetails? in countryDetails }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
