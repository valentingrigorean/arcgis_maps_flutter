//
//  SimpleFillSymbol+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 28.06.2023.
//

import Foundation
import ArcGIS

extension SimpleLineSymbol.Style {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .dash
            break
        case 1:
            self = .dashDot
            break
        case 2:
            self = .dashDotDot
            break
        case 3:
            self = .dot
            break
        case 4:
            self = .longDash
            break
        case 5:
            self = .longDashDot
            break
        case 6:
            self = .noLine
            break
        case 7:
            self = .shortDash
            break
        case 8:
            self = .shortDashDot
            break
        case 9:
            self = .shortDashDotDot
            break
        case 10:
            self = .shortDot
            break
        case 11:
            self = .solid
            break
        default:
            fatalError("Invalid SimpleLineSymbol.Style value \(self)")
        }
    }
}
