//
//  KontryError.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 11/1/21.
//

import Foundation

// Responsibility:
// It is used for mapping all low-level errors to it.
// It is the error received by the ViewModels & Views at the end of data operations.
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
