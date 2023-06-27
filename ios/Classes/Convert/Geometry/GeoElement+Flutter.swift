//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

extension GeoElement {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let geometry = geometry {
            json["geometry"] = geometry.toJSONFlutter()
        }
        json["attributes"] = attributes.toFlutterTypes()
        return json
    }
}
