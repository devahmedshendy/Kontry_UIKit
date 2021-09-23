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
