//
//  Extension+Publisher.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 11/3/21.
//

import Foundation
import Combine

extension Publisher {
    func mapErrorToKontryError() -> AnyPublisher<Output, KontryError> {
        return self
            .mapError { error in KontryError(error) }
            .eraseToAnyPublisher()
    }
}
