//
//  Errors.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/9/21.
//

import Foundation

// Responsibility:
// It would be used to map from low-level errors to high-level errors that make sense for UI.
enum KontryError: Swift.Error, CustomStringConvertible {
    case decoding(description: String)
    case coredata(description: String)
    case network(description: String)
    case unknown(description: String)
    
    var description: String {
        switch self {
        case .network(let description):
            return "NETWORK_ERROR: \(description)"
            
        case .coredata(let description):
            return "COREDATA_ERROR: \(description)"
        
        case .decoding(let description):
            return "DECODING_ERROR: \(description)"
            
        case .unknown(let description):
            return "UNKNOWN_ERROR: \(description)"
        }
    }
}

// Responsibility:
// It is kind of a wrapper for CoreData native error so I can integrate it with Combine.
struct CoreDataError: Swift.Error {
    var description: String
    
    init(description: String) {
        self.description = description
    }
    
    init(error: NSError) {
        self.init(description: String(describing: error.userInfo))
    }
}

