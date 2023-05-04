//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension DirectionEvent {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let estimatedArrivalDate = estimatedArrivalDate {
            json["estimatedArrivalTime"] = estimatedArrivalDate.toIso8601String()
        }
        json["estimatedArrivalTimeShift"] = estimatedArrivalDateShift
        json["eventMessages"] = messages
        json["eventText"] = text

        if let geometry = geometry {
            json["geometry"] = geometry.toJSONFlutter()
        }
        return json
    }
}
