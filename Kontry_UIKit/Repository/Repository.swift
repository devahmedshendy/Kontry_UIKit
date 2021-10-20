//
//  Repository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/22/21.
//

import Foundation
import Combine

final class Repository {
    
    //MARK: - Properties
    
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var restCountriesService = RestCountriesService()
    private lazy var flagPediaService = FlagPediaService()
    private lazy var coreDataService = CoreDataService()
    
    //MARK: - Methods
    
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
    
    func get40WidthFlag(for alpha2Code: String, size: FlagPediaAPI.Size) -> AnyPublisher<Data?, KontryError> {
        return self.flagPediaService
            .getCountryFlag(for: alpha2Code, size: size, enableCache: true)
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
    
    func get160WidthFlag(for alpha2Code: String, size: FlagPediaAPI.Size) -> AnyPublisher<Data?, KontryError> {
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
                    .getCountryFlag(for: alpha2Code, size: size, enableCache: false)
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
    
    private func findCountryDetailsRemotely(for alpha2Code: String) -> AnyPublisher<CountryDetails?, Error> {
        return restCountriesService
            .getCountryByAlpha2Code(alpha2Code, fields: CountryDetails.fields)
            .mapError { $0 as Error }
            // We decode the data - if any - returned by remote api
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
