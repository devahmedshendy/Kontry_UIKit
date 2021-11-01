//
//  PersistenceError.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 10/31/21.
//

import Foundation

// Responsibility:
// It represents the error thrown by the local persistence resource.
struct PersistenceError: Error {
    var localizedDescription: String
    
    init(error: NSError) {
        self.localizedDescription = error.localizedDescription
    }
}
