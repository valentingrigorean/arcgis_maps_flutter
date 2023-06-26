//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension TimeValue {

    convenience init(data: Dictionary<String, Any>) {
        let duration = data["duration"] as! Double
        let unit = data["unit"] as! Int

        self.init(duration: duration,TimeValue.Unit.fromFlutterValue(unit))
    }

    func toJSONFlutter() -> Any {
        [
            "duration": duration,
            "unit": unit?.toFlutterValue() ?? 0
        ]
    }
}