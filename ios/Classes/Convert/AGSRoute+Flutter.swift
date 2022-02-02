//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSRoute {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["directionManeuvers"] = directionManeuvers.map {
            $0.toJSONFlutter()
        }
        if let startTime = startTime {
            json["startTime"] = startTime.toIso8601String()
        }
        json["startTimeShift"] = startTimeShift
        if let endTime = endTime {
            json["endTime"] = endTime.toIso8601String()
        }
        json["endTimeShift"] = endTimeShift
        json["totalLength"] = totalLength
        if let routeGeometry = routeGeometry {
            json["routeGeometry"] = routeGeometry.toJSONFlutter()
        }
        json["routeName"] = routeName
        json["totalTime"] = totalTime
        json["travelTime"] = travelTime
        json["violationTime"] = violationTime
        json["waitTime"] = waitTime
        return json
    }
}