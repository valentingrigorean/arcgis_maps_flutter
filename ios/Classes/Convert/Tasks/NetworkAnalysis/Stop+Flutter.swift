//
// Created by Valentin Grigorean on 18.02.2022.
//

import Foundation
import ArcGIS

extension Stop {
    convenience init(data: Dictionary<String, Any>) {
        let point = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>) as! Point
        self.init(point: point)
        name = data["name"] as? String ?? ""
        kind = Stop.Kind.fromFlutter(data["stopType"] as! Int)
        routeName = data["routeName"] as? String ?? ""
        curbApproach = CurbApproach.fromFlutter(data["curbApproach"] as! Int)
        currentBearingTolerance = data["currentBearingTolerance"] as? Double ?? Double.nan
        navigationLatency = data["navigationLatency"] as? Double ?? Double.nan
        navigationSpeed = data["navigationSpeed"] as? Double ?? Double.nan
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["arrivalCurbApproach"] = arrivalCurbApproach?.toFlutterValue()
        json["departureCurbApproach"] = departureCurbApproach?.toFlutterValue()
        json["curbApproach"] = curbApproach?.toFlutterValue()
        json["currentBearing"] = currentBearing
        json["currentBearingTolerance"] = currentBearingTolerance
        json["distanceToNetworkLocation"] = distanceToNetworkLocation
        if let point = geometry {
            json["geometry"] = point.toJSONFlutter()
        }
        if let arrivalTime = arrivalDate {
            json["arrivalTime"] = arrivalTime.toIso8601String()
        }
        json["arrivalTimeShift"] = arrivalDateShift
        if let departureTime = departureDate {
            json["departureTime"] = departureTime.toIso8601String()
        }
        json["departureTimeShift"] = departureDate
        if let timeWindowStart = timeWindowStart {
            json["timeWindowStart"] = timeWindowStart.toIso8601String()
        }
        if let timeWindowEnd = timeWindowEnd {
            json["timeWindowEnd"] = timeWindowEnd.toIso8601String()
        }
        json["locationStatus"] = locationStatus.toFlutterValue()
        json["name"] = name
        json["stopType"] = kind.toFlutterValue()
        json["stopID"] = id
        json["navigationLatency"] = navigationLatency
        json["navigationSpeed"] = navigationSpeed
        json["routeName"] = routeName
        json["sequence"] = sequence
        json["violationTime"] = violationTime
        json["waitTime"] = waitTime
        return json
    }
}
