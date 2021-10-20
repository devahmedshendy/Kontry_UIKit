//
//  CountryCellvm.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/14/21.
//

import Foundation
import Combine

final class FlagViewModel {
    
    //MARK: - Properties
    
    private lazy var repository: Repository = Repository()
    
    //MARK: - States
    
    //MARK: - Actions
    
    func get40WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return repository
            .get40WidthFlag(for: alpha2Code, size: .w40)
    }
    
    func get160WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return repository
            .get160WidthFlag(for: alpha2Code, size: .w160)
    }
}
