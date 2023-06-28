//
//  SimpleMarkerSymbol+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 28.06.2023.
//

import Foundation
import ArcGIS

extension SimpleMarkerSymbol.Style {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .circle
            break
        case 1:
            self = .cross
            break
        case 2:
            self = .diamond
            break
        case 3:
            self = .square
            break
        case 4:
            self = .triangle
            break
        case 5:
            self = .x
            break
        default:
            fatalError("Invalid SimpleMarkerSymbol.Style value \(self)")
        }
    }
}
