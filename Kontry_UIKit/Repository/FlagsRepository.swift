//
//  FlagsRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

final class FlagsRepository: FlagsRepositoryProtocol {
    
    //MARK: - Properties
    
    private lazy var jsonDecoder = JSONDecoder()
    private var flagsApiService: FlagsApiServiceProtocol
    private var persistenceService: PersistenceServiceProtocol
    
    //MARK: - init Methods
    
    init(
        flagsApiService: FlagsApiServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.flagsApiService = flagsApiService
        self.persistenceService = persistenceService
    }
    
    //MARK: - Data Operations
    
    // Get Flag image from FlagPedia API.
    // It only request flag of width size 40px.
    func get40pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        
        return self.flagsApiService
            .get(by: alpha2Code, size: FlagSize.w40, enableCache: true)
            .mapError { error -> KontryError in
                return .network(description: error.localizedDescription)
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
        
        return persistenceService
            .findFlagEntity(for: alpha2Code)
            .flatMap { [weak self] flag -> AnyPublisher<Data?, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if let flag = flag {
                    return Just(flag.image)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.flagsApiService
                    .get(by: alpha2Code, size: FlagSize.w160, enableCache: false)
                    .map { image -> Data? in
                        guard let image = image else { return nil }

                        self.persistenceService.createFlagEntity(for: alpha2Code, image)

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
}
