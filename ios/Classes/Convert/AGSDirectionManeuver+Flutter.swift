//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSDirectionManeuver {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["directionEvents"] = directionEvents.map {
            $0.toJSONFlutter()
        }
        json["directionText"] = directionText
        if let estimatedArriveTime = estimatedArriveTime {
            json["estimatedArriveTime"] = estimatedArriveTime.toIso8601String()
        }
        json["estimatedArrivalTimeShift"] = estimatedArrivalTimeShift
        json["maneuverMessages"] = maneuverMessages.map {
            $0.toJSONFlutter()
        }
        json["fromLevel"] = fromLevel
        if let geometry = geometry {
            json["geometry"] = geometry.toJSONFlutter()
        }
        json["maneuverType"] = maneuverType.rawValue
        json["toLevel"] = toLevel
        json["length"] = length
        json["duration"] = duration
        return json
    }
}