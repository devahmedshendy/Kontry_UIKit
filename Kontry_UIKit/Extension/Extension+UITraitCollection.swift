//
//  Extension+X.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 11/1/21.
//

import Foundation
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
