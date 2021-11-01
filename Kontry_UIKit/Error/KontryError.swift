//
//  KontryError.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 11/1/21.
//

import Foundation

// Responsibility:
// It would be used to map from low-level errors to high-level errors that make sense for UI.
struct KontryError: Error, CustomStringConvertible {
    var description: String
    
    init(_ error: URLError) {
        description = "NETWORK_ERROR: \(error.userInfo)"
    }
    
    init(_ error: DecodingError) {
        description = "DECODING_ERROR: \(error.localizedDescription)"
    }
    
    init(_ error: PersistenceError) {
        description = "PERSISTENCE_ERROR: \(error.userInfo)"
    }
}
