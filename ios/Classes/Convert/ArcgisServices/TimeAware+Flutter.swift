//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation
import ArcGIS

extension TimeAware {
    func toJSONFlutter(layerId: String? = nil) -> Any {
        var data = [String: Any]()

        if let layerId = layerId {
            data["layerId"] = layerId
        }

        if let fullTimeExtent = fullTimeExtent {
            let json = fullTimeExtent.toJSONFlutter()

            if let fullTimeExtentData = json {
                data["fullTimeExtent"] = fullTimeExtentData
            }
        }

        data["supportsTimeFiltering"] = supportsTimeFiltering
        data["isTimeFilteringEnabled"] = timeFilteringIsEnabled

        if let timeOffset = timeOffset {
            data["timeOffset"] = timeOffset.toJSONFlutter()
        }

        if let timeInterval = timeInterval {
            data["timeInterval"] = timeInterval.toJSONFlutter()
        }

        return data
    }
}