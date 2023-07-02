//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension LocationDisplay.AutoPanMode {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .off
        case 1:
            self = .recenter
        case 2:
            self = .navigation
        case 3:
            self = .compassNavigation
        default:
            fatalError("AutoPanMode not supported")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .off:
            return 0
        case .recenter:
            return 1
        case .navigation:
            return 2
        case .compassNavigation:
            return 3
        @unknown default:
            fatalError("AutoPanMode not supported")
        }
    }
}


extension Location {
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
