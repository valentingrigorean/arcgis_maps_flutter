//
//  SimpleMarkerSymbol+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 28.06.2023.
//

import Foundation
import ArcGIS

extension SimpleMarkerSymbol.Style {
    init(_ flutterValue: String) {
        switch flutterValue {
        case "circle":
            self = .circle
            break
        case "cross":
            self = .cross
            break
        case "diamond":
            self = .diamond
            break
        case "square":
            self = .square
            break
        case "triangle":
            self = .triangle
            break
        case "x":
            self = .x
            break
        default:
            fatalError("Invalid SimpleMarkerSymbol.Style value \(flutterValue)")
        }
    }
}

extension SimpleMarkerSymbol {
    func interpretSimpleMarkerSymbol(data:Dictionary<String, Any>){
        self.interpretMarkerSymbol(data: data)
        if let style = data["style"] as? String {
            self.style = SimpleMarkerSymbol.Style(style)
        }

        if let color = data["color"] {
            self.color = UIColor(data: color)!
        }

        if let size = data["size"] as? Double {
            self.size = CGFloat(size)
        }
    }
}
