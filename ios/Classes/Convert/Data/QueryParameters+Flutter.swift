//
// Created by Valentin Grigorean on 24.04.2024.
//

import Foundation
import ArcGIS

extension SpatialRelationship {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .relate
            break
        case 1:
            self = .equals
            break
        case 2:
            self = .disjoint
            break
        case 3:
            self = .intersects
            break
        case 4:
            self = .touches
            break
        case 5:
            self = .crosses
            break
        case 6:
            self = .within
            break
        case 7:
            self = .contains
            break
        case 8:
            self = .overlaps
            break
        case 9:
            self = .envelopeIntersects
            break
        case 10:
            self = .indexIntersects
            break
        default:
            fatalError("Invalid SpatialRelationship value \(flutterValue)")
        }
    }
}

extension QueryParameters {
    convenience init(data: [String: Any]) {
        self.init()
        if let returnGeometry = data["returnGeometry"] as? Bool {
            self.returnsGeometry = returnGeometry
        }
        if let geometry = data["geometry"] as? [String: Any] {
            self.geometry = Geometry.fromFlutter(data: geometry)
        }
        if let maxFeatures = data["maxFeatures"] as? Int {
            self.maxFeatures = maxFeatures
        }
        if let whereClause = data["whereClause"] as? String {
            self.whereClause = whereClause
        }

        if let spatialRelationship = data["spatialRelationship"] as? Int {
            self.spatialRelationship = SpatialRelationship(spatialRelationship)
        }

        if let resultOffset = data["resultOffset"] as? Int {
            self.resultOffset = resultOffset
        }
    }
}
