//
//  Constants.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/1/21.
//

import Foundation

final class Constant {
    struct ConstraintIdentifier {
        static let navigationBarViewTop = "navigationBarViewTop"
        static let detailStackTrailing = "detailStackTrailing"
        static let detailStackTop = "detailStackTop"
        static let detailStackCenterY = "detailStackCenterY"
        static let detailStackWidth = "detailStackWidth"
        static let mapViewTop = "mapViewTop"
        static let mapViewLeading = "mapViewLeading"
        static let mapViewBottom = "mapViewBottom"
        static let mapViewHeight = "mapViewHeight"
        static let mapViewWidth = "mapViewWidth"
    }
    
    struct Text {
        static let loading = "loading"
        static let retry = "retry"
        static let failedToFetchContent = "Failed to fetch content"
    }
    
    struct Placeholder {
        static let searchByName = "Search By Name"
    }
    
    static let unavailable = "UNAVAILABLE"
    static let badAlpha2Code = "BAD_ALPHA2CODE"
}
