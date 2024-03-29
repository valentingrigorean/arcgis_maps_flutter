//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension AGSTimeExtent {
    convenience init(data: Dictionary<String, Any>) {
        let startTime: Date?
        let endTime: Date?

        if let startTimeStr = data["startTime"] as? String {
            startTime = startTimeStr.toDateFromIso8601()
        } else {
            startTime = nil
        }

        if let endTimeStr = data["endTime"] as? String {
            endTime = endTimeStr.toDateFromIso8601()
        } else {
            endTime = nil
        }

        self.init(startTime: startTime, endTime: endTime)
    }

    func toJSONFlutter() -> Any? {
        var data = Dictionary<String, Any>()
        if let startTime = startTime {
            data["startTime"] = startTime.toIso8601String()
        }
        if let endTime = endTime {
            data["endTime"] = endTime.toIso8601String()
        }

        return data.count == 0 ? nil : data
    }
}