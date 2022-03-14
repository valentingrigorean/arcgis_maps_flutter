//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSDirectionMessage {
    func toJSONFlutter() -> Any {
        [
            "type": type.rawValue,
            "text": text,
        ]
    }
}