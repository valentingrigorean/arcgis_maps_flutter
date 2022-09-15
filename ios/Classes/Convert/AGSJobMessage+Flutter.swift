//
// Created by Valentin Grigorean on 28.07.2022.
//

import Foundation
import ArcGIS

extension AGSJobMessage {
    func toJSONFlutter() -> Any {
        [
            "message": message,
            "severity": severity.rawValue,
            "source": source.rawValue,
            "timestamp": timestamp.toIso8601String()
        ]
    }
}