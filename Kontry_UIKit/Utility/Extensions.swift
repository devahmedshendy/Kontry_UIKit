//
//  extensions.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/20/21.
//

import UIKit

extension UITraitCollection {
    var isRegularWidth: Bool {
        return self.horizontalSizeClass == .regular
    }
    
    var isRegularHeight: Bool {
        return self.verticalSizeClass == .regular
    }
    
    var isCompactHeight: Bool {
        return self.verticalSizeClass == .compact
    }
}

extension Array where Element: Any {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension NSSet {
    func toArray<T>(of type: T.Type) -> [T] {
        return self.allObjects as! [T]
    }
}
