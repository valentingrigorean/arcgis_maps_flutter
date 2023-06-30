//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension Viewpoint {
    init(data: Dictionary<String, Any>) {
        let scale = data["scale"] as! Double
        let targetGeometry = data["targetGeometry"] as! Dictionary<String, Any>

        self.init(center: Point(data: targetGeometry), scale: scale)
    }

    func toJSONFlutter() -> Any {
        [
            "scale": scale,
            "targetGeometry": targetGeometry.toJSONFlutter()
        ]
    }
}
