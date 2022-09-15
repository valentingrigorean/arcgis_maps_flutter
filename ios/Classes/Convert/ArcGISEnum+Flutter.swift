//
// Created by Valentin Grigorean on 16.04.2021.
//

import Foundation
import ArcGIS

extension Int {

    func toAGSViewpointType() -> AGSViewpointType {
        switch self {
        case 0:
            return .centerAndScale
        case 1:
            return .boundingGeometry
        default:
            return .boundingGeometry
        }
    }
}
