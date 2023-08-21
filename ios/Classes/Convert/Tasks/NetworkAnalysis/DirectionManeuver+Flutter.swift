//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension DirectionManeuver {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["directionEvents"] = events.map {
            $0.toJSONFlutter()
        }
        json["directionText"] = text
        if let estimatedArrivalDate = estimatedArrivalDate {
            json["estimatedArriveTime"] = estimatedArrivalDate.toIso8601String()
        }
        json["estimatedArrivalTimeShift"] = estimatedArrivalDateShift
        json["maneuverMessages"] = messages.map {
            $0.toJSONFlutter()
        }
        json["fromLevel"] = fromLevel
        if let geometry = geometry {
            json["geometry"] = geometry.toJSONFlutter()
        }
        json["maneuverType"] = kind.toFlutterValue()
        json["toLevel"] = toLevel
        json["length"] = length.value
        json["duration"] = duration
        return json
    }
}
