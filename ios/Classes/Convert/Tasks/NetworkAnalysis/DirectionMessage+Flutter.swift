//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension DirectionMessage {
    func toJSONFlutter() -> Any {
        [
            "type": kind.toFlutterValue(),
            "text": text,
        ] as [String : Any]
    }
}
