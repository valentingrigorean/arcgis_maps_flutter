//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension AGSViewpoint {
    convenience init(data: Dictionary<String, Any>) {
        let scale = data["scale"] as! Double
        let targetGeometry = data["targetGeometry"] as! Dictionary<String, Any>

        self.init(center: AGSPoint(data: targetGeometry), scale: scale)
    }
}