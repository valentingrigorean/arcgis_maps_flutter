//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSRouteParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        accumulateAttributeNames = data["accumulateAttributeNames"] as! [String]
        directionsDistanceUnits = AGSUnitSystem(rawValue: data["directionsDistanceUnits"] as! Int) ?? .unknown
        directionsLanguage = data["directionsLanguage"] as! String
        directionsStyle = AGSDirectionsStyle(rawValue: data["directionsStyle"] as! Int)!
        findBestSequence = data["findBestSequence"] as! Bool
        if let startTime = data["startTime"] as? String {
            self.startTime = startTime.toDateFromIso8601()
        }
        if let outputSpatialReference = data["outputSpatialReference"] as? Dictionary<String, Any> {
            self.outputSpatialReference = AGSSpatialReference(data: outputSpatialReference)
        }
        preserveFirstStop = data["preserveFirstStop"] as! Bool
        preserveLastStop = data["preserveLastStop"] as! Bool
        returnDirections = data["returnDirections"] as! Bool
        returnPointBarriers = data["returnPointBarriers"] as! Bool
        returnPolygonBarriers = data["returnPolygonBarriers"] as! Bool
        returnPolylineBarriers = data["returnPolylineBarriers"] as! Bool
        returnRoutes = data["returnRoutes"] as! Bool
        returnStops = data["returnStops"] as! Bool
        routeShapeType = AGSRouteShapeType(rawValue: data["routeShapeType"] as! Int)!
        if let travelMode = data["travelMode"] as? Dictionary<String, Any> {
            self.travelMode = AGSTravelMode(data: travelMode)
        }
    }


    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["accumulateAttributeNames"] = accumulateAttributeNames
        json["directionsDistanceUnits"] = directionsDistanceUnits == .unknown ? 2 : directionsDistanceUnits.rawValue
        json["directionsLanguage"] = directionsLanguage
        json["directionsStyle"] = directionsStyle.rawValue
        json["findBestSequence"] = findBestSequence
        if let startTime = startTime {
            json["startTime"] = startTime.toIso8601String()
        }
        if let outputSpatialReference = outputSpatialReference {
            json["outputSpatialReference"] = outputSpatialReference.toJSONFlutter()
        }
        json["preserveFirstStop"] = preserveFirstStop
        json["preserveLastStop"] = preserveLastStop
        json["returnDirections"] = returnDirections
        json["returnPointBarriers"] = returnPointBarriers
        json["returnPolygonBarriers"] = returnPolygonBarriers
        json["returnPolylineBarriers"] = returnPolylineBarriers
        json["returnRoutes"] = returnRoutes
        json["returnStops"] = returnStops
        json["routeShapeType"] = routeShapeType.rawValue
        if let travelMode = travelMode {
            json["travelMode"] = travelMode.toJSONFlutter()
        }
        return json
    }
}