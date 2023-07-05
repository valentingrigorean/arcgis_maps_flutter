//
//  ExportVectorTiles+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 05.07.2023.
//

import Foundation
import ArcGIS

extension EsriVectorTilesDownloadOption {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .useOriginalService
        case 1:
            self = .useReducedFontsService
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .useOriginalService:
            return 0
        case .useReducedFontsService:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}
