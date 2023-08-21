//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension RouteParameters {
    convenience init(data: [String: Any]) {
        self.init()
        addAccumulateAttributeNames(data["accumulateAttributeNames"] as! [String])
        directionsDistanceUnits = UnitSystem(data["directionsDistanceUnits"] as! Int)
        directionsLanguage = data["directionsLanguage"] as! String
        directionsStyle = DirectionsStyle(data["directionsStyle"] as! Int)
        findsBestSequence = data["findBestSequence"] as! Bool
        if let startTime = data["startTime"] as? String {
            startDate = startTime.toDateFromIso8601()
        }
        if let outputSpatialReference = data["outputSpatialReference"] as? [String: Any] {
            self.outputSpatialReference = SpatialReference(data: outputSpatialReference)
        }
        preservesFirstStop = data["preserveFirstStop"] as! Bool
        preservesLastStop = data["preserveLastStop"] as! Bool
        returnsDirections = data["returnDirections"] as! Bool
        returnsPointBarriers = data["returnPointBarriers"] as! Bool
        returnsPolygonBarriers = data["returnPolygonBarriers"] as! Bool
        returnsPolylineBarriers = data["returnPolylineBarriers"] as! Bool
        returnsRoutes = data["returnRoutes"] as! Bool
        returnsStops = data["returnStops"] as! Bool
        routeShapeType = RouteShapeType(data["routeShapeType"] as! Int)
        if let travelMode = data["travelMode"] as? [String: Any] {
            self.travelMode = TravelMode(data: travelMode)
        }
        if let stops = data["stops"] as? [[String: Any]] {
            let stops = stops.map { Stop(data: $0) }
            setStops(stops)
        }
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["accumulateAttributeNames"] = accumulateAttributeNames
        json["directionsDistanceUnits"] = directionsDistanceUnits.toFlutterValue()
        json["directionsLanguage"] = directionsLanguage
        json["directionsStyle"] = directionsStyle.toFlutterValue()
        json["findBestSequence"] = findsBestSequence
        if let startTime = startDate {
            json["startTime"] = startTime.toIso8601String()
        }
        if let outputSpatialReference = outputSpatialReference {
            json["outputSpatialReference"] = outputSpatialReference.toJSONFlutter()
        }
        json["preserveFirstStop"] = preservesFirstStop
        json["preserveLastStop"] = preservesLastStop
        json["returnDirections"] = returnsDirections
        json["returnPointBarriers"] = returnsPointBarriers
        json["returnPolygonBarriers"] = returnsPolygonBarriers
        json["returnPolylineBarriers"] = returnsPolylineBarriers
        json["returnRoutes"] = returnsRoutes
        json["returnStops"] = returnsStops
        json["routeShapeType"] = routeShapeType.toFlutterValue()
        if let travelMode = travelMode {
            json["travelMode"] = travelMode.toJSONFlutter()
        }
        return json
    }
}
