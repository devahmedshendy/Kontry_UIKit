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
    
    private lazy var repository: Repository = Repository()
    
    //MARK: - States
    
    //MARK: - Actions
    
    func get40WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return repository
            .get40pxWidthFlag(for: alpha2Code)
    }
    
    func get160WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return repository
            .get160pxWidthFlag(for: alpha2Code)
    }
}
