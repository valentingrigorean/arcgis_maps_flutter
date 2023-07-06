//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension Viewpoint {
    init(data: [String: Any]) {
        let scale = data["scale"] as! Double
        let targetGeometry = data["targetGeometry"] as! [String: Any]

        self.init(center: Point(data: targetGeometry), scale: scale)
    }

    func toJSONFlutter() -> Any {
        [
            "scale": targetScale,
            "targetGeometry": targetGeometry.toJSONFlutter()
        ]
    }
}

extension Viewpoint.Kind{
    init(_ flutterValue:Int){
        switch flutterValue{
        case 0:
            self = .centerAndScale
            break
        case 1:
            self = .boundingGeometry
            break
        default:
            fatalError("Unknown Viewpoint.Kind")
        }
    }
}
