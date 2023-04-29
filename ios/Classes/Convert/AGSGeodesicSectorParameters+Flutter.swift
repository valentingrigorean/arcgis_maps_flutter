//
// Created by Valentin Grigorean on 29.10.2022.
//

import Foundation
import ArcGIS

extension AGSGeodesicSectorParameters {
    convenience init(data: Dictionary<String, Any>) {
        let center = Point(data: data["center"] as! Dictionary<String, Any>)
        let semiAxis1Length = data["semiAxis1Length"] as! Double
        let semiAxis2Length = data["semiAxis2Length"] as! Double
        let startDirection = data["startDirection"] as! Double
        let sectorAngle = data["sectorAngle"] as! Double
        self.init(center: center, semiAxis1Length: semiAxis1Length, semiAxis2Length: semiAxis2Length, sectorAngle: startDirection, startDirection: sectorAngle)

        let linearUnitId = AGSLinearUnitID.fromFlutter(data["linearUnit"] as! Int)
        let angularUnitId = AGSAngularUnitID.fromFlutter(data["angularUnit"] as! Int)
        angularUnit = AGSAngularUnit(unitID: angularUnitId)!
        linearUnit = AGSLinearUnit(unitID: linearUnitId)!
        axisDirection = data["axisDirection"] as! Double
        if let maxSegmentLength = data["maxSegmentLength"] as? Double {
            self.maxSegmentLength = maxSegmentLength
        }
        geometryType = AGSGeometryType(rawValue: data["geometryType"] as! Int)!
        maxPointCount = data["maxPointCount"] as! Int
    }
}
