//
// Created by Valentin Grigorean on 29.10.2022.
//

import Foundation
import ArcGIS

extension GeodesicSectorParameters {
    init(data: [String: Any]) where Geometry: ArcGIS.Multipart {
        self.init()
        center = Point(data: data["center"] as! [String: Any])
        semiAxis1Length = data["semiAxis1Length"] as! Double
        semiAxis2Length = data["semiAxis2Length"] as! Double
        startDirection = data["startDirection"] as! Double
        sectorAngle = data["sectorAngle"] as! Double
        linearUnit = LinearUnit(data["linearUnit"] as! Int)!
        angularUnit = AngularUnit(data["angularUnit"] as! Int)!
        axisDirection = data["axisDirection"] as! Double
        if let maxSegmentLength = data["maxSegmentLength"] as? Double {
            self.maxSegmentLength = maxSegmentLength
        }
        maxPointCount = data["maxPointCount"] as! Int
    }

    static func createGeodesicSectorParameters(data: [String: Any]) -> GeodesicSectorParameters<Geometry> {
        let geometryType = GeometryType(rawValue: data["geometryType"] as! Int)!
        switch geometryType {
        case .polyline:
            return GeodesicSectorParameters<Polyline>(data: data) as! GeodesicSectorParameters<Geometry>
        case .polygon:
            return GeodesicSectorParameters<Polygon>(data: data) as! GeodesicSectorParameters<Geometry>
//        case .multipoint:
//            GeodesicSectorParameters<Multipart>(data: data)
        default:
            fatalError("GeometryType not supported")
        }
    }
}
