//
// Created by Valentin Grigorean on 18.02.2022.
//

import Foundation
import ArcGIS

extension AGSStop {
    convenience init(data: Dictionary<String, Any>) {
        let point = AGSGeometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>) as! AGSPoint
        self.init(point: point)
        name = data["name"] as? String ?? ""
        stopType = AGSStopType(rawValue: data["stopType"] as! UInt) ?? .stop
        routeName = data["routeName"] as? String ?? ""
        curbApproach = AGSCurbApproach(rawValue: data["curbApproach"] as! Int) ?? .unknown
        currentBearingTolerance = data["currentBearingTolerance"] as? Double ?? Double.nan
        navigationLatency = data["navigationLatency"] as? Double ?? Double.nan
        navigationSpeed = data["navigationSpeed"] as? Double ?? Double.nan
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["arrivalCurbApproach"] = arrivalCurbApproach.rawValue
        json["departureCurbApproach"] = departureCurbApproach.rawValue
        json["curbApproach"] = curbApproach.rawValue
        json["currentBearing"] = currentBearing
        json["currentBearingTolerance"] = currentBearingTolerance
        json["distanceToNetworkLocation"] = distanceToNetworkLocation
        if let point = geometry {
            json["geometry"] = point.toJSONFlutter()
        }
        if let arrivalTime = arrivalTime {
            json["arrivalTime"] = arrivalTime.toIso8601String()
        }
        json["arrivalTimeShift"] = arrivalTimeShift
        if let departureTime = departureTime {
            json["departureTime"] = departureTime.toIso8601String()
        }
        json["departureTimeShift"] = departureTimeShift
        if let timeWindowStart = timeWindowStart {
            json["timeWindowStart"] = timeWindowStart.toIso8601String()
        }
        if let timeWindowEnd = timeWindowEnd {
            json["timeWindowEnd"] = timeWindowEnd.toIso8601String()
        }
        json["locationStatus"] = locationStatus.rawValue
        json["name"] = name
        json["stopType"] = stopType.rawValue
        json["stopID"] = stopID
        json["navigationLatency"] = navigationLatency
        json["navigationSpeed"] = navigationSpeed
        json["routeName"] = routeName
        json["sequence"] = sequence
        json["violationTime"] = violationTime
        json["waitTime"] = waitTime
        return json
    }
}