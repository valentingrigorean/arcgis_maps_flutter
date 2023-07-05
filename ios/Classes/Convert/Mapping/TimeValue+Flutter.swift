//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension TimeValue {

    init(data: Dictionary<String, Any>) {
        let duration = data["duration"] as! Double
        let unit = TimeValue.Unit(data["unit"] as! Int)
        self.init(duration: duration, unit: unit)
    }

    func toJSONFlutter() -> Any {
        [
            "duration": duration,
            "unit": unit?.toFlutterValue() ?? 0
        ] as Dictionary<String, Any>
    }
}
