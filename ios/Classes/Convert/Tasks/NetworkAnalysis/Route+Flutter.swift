//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension Route {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["directionManeuvers"] = directionManeuvers.map {
            $0.toJSONFlutter()
        }
        if let startDate = startDate {
            json["startTime"] = startDate.toIso8601String()
        }
        json["startTimeShift"] = startDateShift
        if let endDate = endDate {
            json["endTime"] = endDate.toIso8601String()
        }
        json["endTimeShift"] = endDateShift
        json["totalLength"] = totalLength.value
        if let routeGeometry = geometry {
            json["routeGeometry"] = routeGeometry.toJSONFlutter()
        }
        json["stops"] = stops.map {
            $0.toJSONFlutter()
        }
        json["routeName"] = name
        json["totalTime"] = totalTime / 60
        json["travelTime"] = travelTime / 60
        json["violationTime"] = violationTime / 60
        json["waitTime"] = waitTime / 60
        return json
    }
}
