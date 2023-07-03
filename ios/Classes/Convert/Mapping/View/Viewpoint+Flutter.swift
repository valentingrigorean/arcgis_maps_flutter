//
//  Viewpoint+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 03.07.2023.
//

import Foundation
import ArcGIS

extension Viewpoint.Kind{
    init(_ flutterValue:Int){
        switch flutterValue{
        case 0:
            self = .centerAndScale
            break
        case 1:
            self = .boundingGeometry
            break
        default:
            fatalError("Unknown Viewpoint.Kind")
        }
    }
}
