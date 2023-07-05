//
// Created by Valentin Grigorean on 09.12.2021.
//

import Foundation
import ArcGIS

extension GeodeticDistanceResult {
    func toJSONFlutter() -> Any {
        [
            "distance": distance.value,
            "distanceUnitId": distance.unit.linearUnit?.toFlutterValue() ?? LinearUnit.defaultFlutterValue,
            "azimuth1": azimuth1.value,
            "azimuth2": azimuth2.value,
        ] as [String: Any]
    }
}
