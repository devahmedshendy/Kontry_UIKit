//
//  Extension+NSSet.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 11/1/21.
//

import Foundation

extension NSSet {
    func toArray<T>(of type: T.Type) -> [T] {
        return self.allObjects as! [T]
    }
}
