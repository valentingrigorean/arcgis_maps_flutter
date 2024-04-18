//
//  SimpleFillSymbol+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 28.06.2023.
//

import Foundation
import ArcGIS

extension SimpleLineSymbol.Style {
    init(_ flutterValue: String) {
        switch flutterValue {
        case "dash":
            self = .dash
            break
        case "dashDot":
            self = .dashDot
            break
        case "dashDotDot":
            self = .dashDotDot
            break
        case "dot":
            self = .dot
            break
        case "longDash":
            self = .longDash
            break
        case "longDashDot":
            self = .longDashDot
            break
        case "none":
            self = .noLine
            break
        case "shortDash":
            self = .shortDash
            break
        case "shortDashDot":
            self = .shortDashDot
            break
        case "shortDashDotDot":
            self = .shortDashDotDot
            break
        case "shortDot":
            self = .shortDot
            break
        case "solid":
            self = .solid
            break
        default:
            fatalError("Invalid SimpleLineSymbol.Style value \(flutterValue)")
        }
    }
}

extension SimpleLineSymbol.MarkerPlacement{
    init(_ flutterValue: String) {
        switch flutterValue {
        case "begin":
            self = .begin
            break
        case "end":
            self = .end
            break
        case "beginAndEnd":
            self = .beginAndEnd
            break
        default:
            fatalError("Invalid SimpleLineSymbol.MarkerPlacement value \(flutterValue)")
        }
    }
}

extension SimpleLineSymbol.MarkerStyle{
    init(_ flutterValue: String) {
        switch flutterValue {
        case "none":
            self = .noMarkers
            break
        case "arrow":
            self = .arrow
            break
        default:
            fatalError("Invalid SimpleLineSymbol.MarkerStyle value \(flutterValue)")
        }
    }
}

extension SimpleLineSymbol{
    func interpretSimpleLineSymbol(data:Dictionary<String, Any>){
        self.interpretLineSymbol(data:data)
        if let style = data["style"] as? String {
            self.style = SimpleLineSymbol.Style(style)
        }
        if let markerPlacement = data["markerPlacement"] as? String {
            self.markerPlacement = SimpleLineSymbol.MarkerPlacement(markerPlacement)
        }
        if let markerStyle = data["markerStyle"] as? String {
            self.markerStyle = SimpleLineSymbol.MarkerStyle(markerStyle)
        }
    }
}
