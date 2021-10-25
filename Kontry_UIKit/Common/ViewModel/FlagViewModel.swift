//
//  CountryCellvm.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/14/21.
//

import Foundation
import Combine

// Responsibility:
// A viewmodel that handles data/state required by any view displaying a country flag (ex: DetailsFlagImageView).
final class FlagViewModel {
    
    //MARK: - Properties
    
    private lazy var flagsRepository: FlagsRepository = FlagsRepository()
    
    //MARK: - States
    
    //MARK: - Actions
    
    func get40WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return flagsRepository
            .get40pxWidthFlag(for: alpha2Code)
    }
    
    func get160WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return flagsRepository
            .get160pxWidthFlag(for: alpha2Code)
    }
}
