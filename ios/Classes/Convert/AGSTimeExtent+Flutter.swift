//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension AGSTimeExtent {
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