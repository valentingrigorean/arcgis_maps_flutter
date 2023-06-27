//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

extension IdentifyLayerResult {
    func toJSONFlutter() -> Any {
        let elements = geoElements.map {
            $0.toJSONFlutter()
        }
        return [
            "layerName": layerContent.name,
            "elements": elements
        ] as [String:Any]
    }
}

extension Array where Element == IdentifyLayerResult {
    func toJSONFlutter() -> [Any] {
        self.map {
            $0.toJSONFlutter()
        }
    }
}
