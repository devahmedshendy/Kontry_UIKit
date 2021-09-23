//
//  CountryCellvm.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/14/21.
//

import Foundation
import Combine

final class CountryCellViewModel {
    
    //MARK: - Properties
    
    private lazy var repository: Repository = {
       return Repository()
    }()
    
    //MARK: - States
    
    //MARK: - Actions
    
    func get24PixelFlag(countryCode: String) -> AnyPublisher<Data, CountryFlagsApiError> {
        return repository
            .getCountryFlag(countryCode: countryCode, size: FlagSize.size24)
    }
}
