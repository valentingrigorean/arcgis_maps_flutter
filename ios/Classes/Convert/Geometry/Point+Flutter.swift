//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension Point {
    convenience init(data: Dictionary<String, Any>) {
        let x = data["x"] as! Double
        let y = data["y"] as! Double

        let z = data["z"] as? Double
        let m = data["m"] as? Double

        let spatialReferenceData = data["spatialReference"] as? Dictionary<String,Any>

        let spatialReference = spatialReferenceData == nil ? nil : SpatialReference(data: spatialReferenceData!)

        if z != nil && m != nil && spatialReference != nil {
            self.init(x: x, y: y, z: z!, m: m!, spatialReference: spatialReference)
            return
        }
        self.init(x: x, y: y, spatialReference: spatialReference)
    }
}
