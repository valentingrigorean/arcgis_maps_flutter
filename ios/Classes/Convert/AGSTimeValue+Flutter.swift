//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension AGSTimeValue {

    convenience init(data: Dictionary<String, Any>) {
        let duration = data["duration"] as! Double
        let unit = data["unit"] as! Int

        self.init(duration: duration, unit: AGSTimeUnit.init(rawValue: unit - 1) ?? .unknown)
    }

    func toJSONFlutter() -> Any {
        [
            "duration": duration,
            "unit": unit.rawValue
        ]
    }
}