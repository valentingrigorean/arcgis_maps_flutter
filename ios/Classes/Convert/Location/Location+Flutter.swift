//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension Location{
    func toJSONFlutter() -> Any {
        [
             "course": course,
             "horizontalAccuracy": horizontalAccuracy,
             "lastKnown": isLastKnown,
             "position": position.toJSONFlutter(),
             "speed": speed,
             "timestamp": timestamp.toIso8601String(),
             "verticalAccuracy": verticalAccuracy
         ]
    }
}