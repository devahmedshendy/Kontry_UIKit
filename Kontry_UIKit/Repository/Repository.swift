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
    
    //MARK: - RestCountries API Methods
    
    func fetchCountryList() -> AnyPublisher<[Country], RestCountriesAPI.Error> {
        return restCountriesService
            .getAllCountries()
            .map { $0.data }
            .decode(type: [Country].self, decoder: jsonDecoder)
            .mapError { error -> RestCountriesAPI.Error in
                switch error {
                case is URLError:
                    return .network(error: "NetworkError: \(error.localizedDescription)")
                    
                case is DecodingError:
                    return .decoding(error: "DecodingError: \(error.localizedDescription)")
                    
                default:
                    return error as? RestCountriesAPI.Error ?? .unknown(error: "UnknownError: \(error.localizedDescription)")
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getCountryFlag(countryCode: String, size: FlagPediaAPI.Size) -> AnyPublisher<Data, FlagPediaAPI.Error> {
        return flagPediaService
            .getCountryFlag(countryCode: countryCode, size: size)
            .tryMap { result -> Data in
                let response = result.response as! HTTPURLResponse
                let statusCode = response.statusCode
                
                if statusCode == 404 {
                    throw FlagPediaAPI.Error.notFound(error: "Flag not found for country code: \(countryCode), with size: \(size)")
                }
                
                return result.data
            }
            .mapError { error -> FlagPediaAPI.Error in
                switch error {
                case is URLError:
                    return .network(error: error.localizedDescription)
                    
                default:
                    return error as? FlagPediaAPI.Error ?? .unknown(error: "UnknownError: \(error.localizedDescription)")
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCountryDetails(of code: String) -> AnyPublisher<CountryDetails, RestCountriesAPI.Error> {
        return restCountriesService
            .getCountryByCode(code)
            .tryMap { result -> Data in
                let response = result.response as! HTTPURLResponse
                let statusCode = response.statusCode
                
                if statusCode == 404 {
                    throw RestCountriesAPI.Error.notFound(error: "Country not found for country code: \(code)")
                }
                
                return result.data
            }
            .decode(type: CountryDetails.self, decoder: jsonDecoder)
            .mapError{ error -> RestCountriesAPI.Error in
                print(error)
                switch error {
                case is URLError:
                    return .network(error: "NetworkError: \(error.localizedDescription)")
                    
                case is DecodingError:
                    return .decoding(error: "DecodingError: \(error.localizedDescription)")
                    
                default:
                    return error as? RestCountriesAPI.Error ?? .unknown(error: "UnknownError: \(error.localizedDescription)")
                }
            }
            .eraseToAnyPublisher()
    }
}
