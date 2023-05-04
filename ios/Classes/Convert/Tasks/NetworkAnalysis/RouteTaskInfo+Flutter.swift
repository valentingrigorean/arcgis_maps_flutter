//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension RouteTaskInfo {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["accumulateAttributeNames"] = accumulateAttributeNames
        if let costAttributes = costAttributes {
            json["costAttributes"] = costAttributes.mapValues({ $0.toJSONFlutter() })
        }
        json["defaultTravelModeName"] = defaultTravelModeName
        json["directionsDistanceUnits"] = directionsDistanceUnits == .unknown ? 2 : directionsDistanceUnits.rawValue
        json["directionsLanguage"] = directionsLanguage
        json["directionsStyle"] = directionsStyle.rawValue
        json["findBestSequence"] = findBestSequence
        json["maxLocatingDistance"] = maxLocatingDistance
        if let startTime = startTime {
            json["startTime"] = startTime.toIso8601String()
        }
        json["networkName"] = networkName
        if let outputSpatialReference = outputSpatialReference {
            json["outputSpatialReference"] = outputSpatialReference.toJSONFlutter()
        }
        json["preserveFirstStop"] = preserveFirstStop
        json["preserveLastStop"] = preserveLastStop
        if let restrictionAttributes = restrictionAttributes {
            json["restrictionAttributes"] = restrictionAttributes.mapValues({ $0.toJSONFlutter() })
        }
        json["routeShapeType"] = routeShapeType.rawValue
        json["supportedLanguages"] = supportedLanguages
        json["supportedRestrictionUsageParameterValues"] = supportedRestrictionUsageParameterValues
        json["directionsSupport"] = directionsSupport.rawValue + 1
        json["travelModes"] = travelModes.map({ $0.toJSONFlutter() })
        json["supportsRerouting"] = supportsRerouting
        return json
    }
}
