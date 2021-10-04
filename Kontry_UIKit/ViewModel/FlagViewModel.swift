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
    
    func get40WidthFlag(countryCode: String) -> AnyPublisher<Data, FlagPediaAPI.Error> {
        return repository
            .getCountryFlag(countryCode: countryCode, size: .w40)
    }
    
    func get160WidthFlag(countryCode: String) -> AnyPublisher<Data, FlagPediaAPI.Error> {
        return repository
            .getCountryFlag(countryCode: countryCode, size: .w160)
    }
}
