//
//  TheFlagsRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

// Responsibility
// It is the next component after ViewModels.
// It communicates with remote/local resources for data about countries.
final class TheFlagsRepository: FlagsRepository {
    
    //MARK: - Properties
    
    private let jsonDecoder: JSONDecoder
    private let remoteFlagsSource: RemoteFlagsSource
    private let localPersistenceSource: LocalPersistenceSource
    
    //MARK: - init Methods
    
    init(
        jsonDecoder: JSONDecoder,
        remoteFlagsSource: RemoteFlagsSource,
        localPersistenceSource: LocalPersistenceSource
    ) {
        self.jsonDecoder = jsonDecoder
        self.remoteFlagsSource = remoteFlagsSource
        self.localPersistenceSource = localPersistenceSource
    }
    
    //MARK: - Data Operations
    
    // Get Flag image from FlagPedia API.
    // It only request flag of width size 40px.
    func get40pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        
        return self.remoteFlagsSource
            .get(by: alpha2Code, size: FlagSize.w40, enableCache: true)
            .mapErrorToKontryError()
    }
    
    // Get Flag image from CoreData or FlagPedia API.
    // It only request flag of width size 160px.
    //
    // This flag is required to be saved in coredata for future requests.
    // It first checks if it is already in coredata then return it,
    //   otherwise request it from the API, then save it in coredata.
    func get160pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        
        return localPersistenceSource
            .findFlagEntity(for: alpha2Code)
            .flatMap { [weak self] flag -> AnyPublisher<Data?, Error> in
                guard let self = self else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                if let flag = flag {
                    return Just(flag.image)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.remoteFlagsSource
                    .get(by: alpha2Code, size: FlagSize.w160, enableCache: false)
                    .map { image -> Data? in
                        guard let image = image else { return nil }

                        self.localPersistenceSource.createFlagEntity(for: alpha2Code, image)

                        return image
                    }
                    .eraseToAnyPublisher()
            }
            .mapErrorToKontryError()
    }
}
