//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension AGSTimeAware {
    func toJSONFlutter(layerId: String? = nil) -> Any {
        var data = Dictionary<String, Any>()

        if let layerId = layerId {
            data["layerId"] = layerId
        }

        if let fullTimeExtent = fullTimeExtent {
            var fullTimeExtentData = fullTimeExtent.toJSONFlutter()

            if let fullTimeExtentData = fullTimeExtentData {
                data["fullTimeExtent"] = fullTimeExtentData
            }
        }

        data["supportsTimeFiltering"] = supportsTimeFiltering
        data["isTimeFilteringEnabled"] = isTimeFilteringEnabled

        if let timeOffset = timeOffset {
            data["timeOffset"] = timeOffset.toJSONFlutter()
        }

        if let timeInterval = timeInterval {
            data["timeInterval"] = timeInterval.toJSONFlutter()
        }

        return data
    }
}