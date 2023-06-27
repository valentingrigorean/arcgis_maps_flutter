//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension TimeValue {

    init(data: Dictionary<String, Any>) {
        duration = data["duration"] as! Double
        unit = TimeValue.Unit(data["unit"] as! Int)
    }

    func toJSONFlutter() -> Any {
        [
            "duration": duration,
            "unit": unit?.toFlutterValue() ?? 0
        ]
    }
}
