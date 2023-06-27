//
// Created by Valentin Grigorean on 09.12.2021.
//

import Foundation
import ArcGIS

extension GeodeticDistanceResult {
    func toJSONFlutter() -> Any {
        [
            "distance": distance,
            "distanceUnitId": distanceUnit?.unitID.toFlutter() ?? AGSLinearUnitID.other.toFlutter(),
            "azimuth1": azimuth1,
            "azimuth2": azimuth2,
            "angularUnitId": azimuthUnit?.unitID.toFlutter() ?? AGSAngularUnitID.other.toFlutter(),
        ]
    }
}
