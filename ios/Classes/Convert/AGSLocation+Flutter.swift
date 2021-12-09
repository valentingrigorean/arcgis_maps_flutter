//
// Created by Valentin Grigorean on 09.12.2021.
//

import Foundation
import ArcGIS

extension AGSLocation {
    func toJSONFlutter() -> Any {
        [
            "course": course,
            "horizontalAccuracy": horizontalAccuracy,
            "lastKnown": lastKnown,
            "position": position?.toJSONFlutter(),
            "velocity": velocity,
            "timestamp": timestamp.toIso8601String(),
            "verticalAccuracy": verticalAccuracy
        ]
    }
}