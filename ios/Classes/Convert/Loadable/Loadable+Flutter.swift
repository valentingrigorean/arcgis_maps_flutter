//
//  Loadable+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 01.05.2023.
//

import Foundation
import ArcGIS

extension LoadStatus{
    func toFlutterValue() -> Int{
        switch self {
        case .notLoaded:
            return 0
        case .loading:
            return 1
        case .loaded:
            return 2
        case .failed:
            return 3
        }
    }
}
