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
    
    private lazy var restCountriesService: RestCountriesService = RestCountriesService()
    private lazy var countryFlagsService: CountryFlagsService = CountryFlagsService()
    
    //MARK: - RestCountries API Methods
    
    func fetchCountryList() -> AnyPublisher<[Country], RestCountriesApiError> {
        return restCountriesService
            .getAllCountries()
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .mapError { error -> RestCountriesApiError in
                switch error {
                case is URLError:
                    return .network(error: "NetworkError: \(error.localizedDescription)")
                    
                case is DecodingError:
                    return .decoding(error: "DecodingError: \(error.localizedDescription)")
                    
                default:
                    return error as? RestCountriesApiError ?? .unknown(error: "UnknownError: \(error.localizedDescription)")
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func getCountryFlag(countryCode: String, size: FlagSize) -> AnyPublisher<Data, CountryFlagsApiError> {
        return countryFlagsService
            .getCountryFlag(countryCode: countryCode, size: size)
            .tryMap { result -> Data in
                let response = result.response as! HTTPURLResponse
                let statusCode = response.statusCode
                
                if statusCode == 404 {
                    throw CountryFlagsApiError.flagNotFound(error: "Flag not found for country code: \(countryCode), with size: \(size)")
                }
                
                return result.data
            }
            .mapError { error -> CountryFlagsApiError in
                switch error {
                case is URLError:
                    return .network(error: error.localizedDescription)
                    
                default:
                    return error as? CountryFlagsApiError ?? .unknown(error: "UnknownError: \(error.localizedDescription)")
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func processAllCountriesRequest(data: Data?, error: Error?) -> Result<[Country], Error> {
        guard let data = data else {
            return .failure(error!)
        }
        
        do {
            let result = try JSONDecoder().decode([Country].self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
