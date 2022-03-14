//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSDirectionEvent {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let estimatedArrivalTime = estimatedArrivalTime {
            json["estimatedArrivalTime"] = estimatedArrivalTime.toIso8601String()
        }
        json["estimatedArrivalTimeShift"] = estimatedArrivalTimeShift
        json["eventMessages"] = eventMessages
        json["eventText"] = eventText

        if let geometry = geometry {
            json["geometry"] = geometry.toJSONFlutter()
        }
        return json
    }
}