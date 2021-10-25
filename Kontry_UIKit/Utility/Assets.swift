//
//  Assets.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/30/21.
//

import UIKit

// Responsibility:
// It holds all project assets as constants in organized classes.
final class Asset {
    class Placeholder {
        static let w25Flag = UIImage(named: "w25_flag")!
        static let w25FlagError = UIImage(named: "w25_flag_error")!
        static let w200Flag = UIImage(named: "w200_flag")!
        static let w200FlagError = UIImage(named: "w200_flag_error")!
    }

    class Color {
        static let screenBackground = UIColor(named: "screen_background")!
        static let detailViewBackground = UIColor(named: "detail_view_backgound")!
        static let text = UIColor(named: "text")!
        static let countryCellBorder = UIColor(named: "country_cell_border")!
        static let detailFlagShadow = UIColor(named: "detail_flag_shadow")!
        static let navigationBarShadow = UIColor(named: "navigation_bar_shadow")!
    }

    class Icon {
        static let capital = UIImage(named: "capital")!
        static let region = UIImage(named: "region")!
        static let population = UIImage(named: "population")!
        static let currency = UIImage(named: "currency")!
        static let language = UIImage(named: "language")!
    }
    
    class Image {
        static let loading = UIImage(named: "loading")
        static let retryError = UIImage(named: "retry_error")
    }
}
