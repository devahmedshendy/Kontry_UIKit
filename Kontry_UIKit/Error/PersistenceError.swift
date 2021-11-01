//
//  PersistenceError.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 10/31/21.
//

import Foundation

// Responsibility:
// It is kind of a wrapper for CoreData native error so I can integrate it with Combine.
struct PersistenceError: Error {
    var userInfo: [String : Any]
    
    init(error: NSError) {
        self.userInfo = error.userInfo
    }
}
