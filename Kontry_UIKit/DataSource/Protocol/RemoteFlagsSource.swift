//
//  RemoteFlagsSource.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/21/21.
//

import Foundation
import Combine

protocol RemoteFlagsSource {
    func get(by field: String, size: FlagSize, enableCache: Bool) -> AnyPublisher<Data?, Error>
}

enum FlagSize {
    case w20
    case w40
    case w160
    case w320
    case w640
}
