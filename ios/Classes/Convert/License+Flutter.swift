//
//  License+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 30.04.2023.
//

import Foundation
import ArcGIS


extension License.Status{
    func toFlutterValue() -> Int {
        switch(self){
        case .invalid:
            return 0
        case .expired:
            return 1
        case .loginRequired:
            return 2
        case .valid:
            return 3
        @unknown default:
            return 0
        }
    }
}
