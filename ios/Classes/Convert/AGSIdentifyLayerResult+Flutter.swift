//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

extension AGSIdentifyLayerResult {
    func toJSONFlutter() -> Any {
        let elements = geoElements.map {
            $0.toJSONFlutter()
        }
        return [
            "layerName": layerContent.name,
            "elements": elements
        ]
    }
}

extension Array where Element == AGSIdentifyLayerResult {
    func toJSONFlutter() -> [Any] {
        self.map {
            $0.toJSONFlutter()
        }
    }


}
