//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension RouteTaskInfo {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["accumulateAttributeNames"] = accumulateAttributeNames
        json["costAttributes"] = costAttributes.mapValues({ $0.toJSONFlutter() })
        json["defaultTravelModeName"] = defaultTravelModeName
        json["directionsDistanceUnits"] = directionsDistanceUnits.toFlutterValue()
        json["directionsLanguage"] = directionsLanguage
        json["directionsStyle"] = directionsStyle.toFlutterValue()
        json["findBestSequence"] = findsBestSequence
        json["maxLocatingDistance"] = maxLocatingDistance
        if let startTime = startDate {
            json["startTime"] = startTime.toIso8601String()
        }
        json["networkName"] = networkName
        if let outputSpatialReference = outputSpatialReference {
            json["outputSpatialReference"] = outputSpatialReference.toJSONFlutter()
        }
        json["preserveFirstStop"] = preservesFirstStop
        json["preserveLastStop"] = preservesLastStop
        json["restrictionAttributes"] = restrictionAttributes.mapValues({ $0.toJSONFlutter() })
        json["routeShapeType"] = routeShapeType?.toFlutterValue()
        json["supportedLanguages"] = supportedLanguages
        json["supportedRestrictionUsageParameterValues"] = supportedRestrictionUsageParameterValues
        json["directionsSupport"] = directionsSupport?.toFlutterValue()
        json["travelModes"] = travelModes.map({ $0.toJSONFlutter() })
        json["supportsRerouting"] = supportsRerouting
        return json
    }
}
