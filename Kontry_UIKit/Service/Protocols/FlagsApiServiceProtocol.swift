//
//  FlagsApiProtocol.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/21/21.
//

import Foundation
import Combine

protocol FlagsApiServiceProtocol {
    func get(by field: String, size: FlagSize, enableCache: Bool) -> AnyPublisher<Data?, Error>
}
