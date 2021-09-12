//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension AGSTimeValue {
    func toJSONFlutter() -> Any {
        [
            "duration": duration,
            "unit": unit.rawValue
        ]
    }
}