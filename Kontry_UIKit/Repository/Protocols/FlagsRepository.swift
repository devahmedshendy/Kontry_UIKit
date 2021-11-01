//
//  FlagsRepository.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

protocol FlagsRepository {
    func get40pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError>
    func get160pxWidthFlag(for alpha2Code: String) -> AnyPublisher<Data?, KontryError>
}
