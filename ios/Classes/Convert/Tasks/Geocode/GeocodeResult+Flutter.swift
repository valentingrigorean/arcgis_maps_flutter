//
// Created by Valentin Grigorean on 09.11.2021.
//

import Foundation
import ArcGIS

extension GeocodeResult {
    func toJSONFlutter() -> Any {
        var data = [String: Any]()
        
        data["attributes"] = attributes.toFlutterTypes()
        
        if let displayLocation = displayLocation {
            data["displayLocation"] = displayLocation.toJSONFlutter()
        }
        if let extent = extent {
            data["extent"] = extent.toJSONFlutter()
        }

        if let inputLocation = inputLocation {
            data["inputLocation"] = inputLocation.toJSONFlutter()
        }

        data["label"] = label

        if let routeLocation = routeLocation {
            data["routeLocation"] = routeLocation.toJSONFlutter()
        }

        data["score"] = score
        return data
    }
}
