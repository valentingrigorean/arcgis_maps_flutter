//
// Created by Valentin Grigorean on 14.09.2021.
//

import Foundation
import ArcGIS

extension AGSLevelOfDetail {
    convenience init(data: [Any]) {
        self.init(level: data[0] as! Int, resolution: data[1] as! Double, scale: data[2] as! Double)
    }

    func toJSONFlutter() -> Any {
        [level, resolution, scale]
    }
}