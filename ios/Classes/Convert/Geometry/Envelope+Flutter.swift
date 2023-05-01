//
// Created by Valentin Grigorean on 14.09.2021.
//

import Foundation
import ArcGIS

extension Envelope {
    convenience init(data: Dictionary<String, Any>) {
        let bbox = data["bbox"] as! [Any]

        let spatialReference = data["spatialReference"] as? Dictionary<String, Any>

        if (bbox.count == 4) {
            self.init(xMin: bbox[0] as! Double, yMin: bbox[1] as! Double, xMax: bbox[2] as! Double, yMax: bbox[3] as! Double, spatialReference: spatialReference == nil ? nil : SpatialReference(data: spatialReference!))
            return
        }

        fatalError("Not implemented")
    }
}
