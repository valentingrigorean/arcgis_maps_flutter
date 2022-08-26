//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension AGSSyncLayerResult {
    func toJSONFlutter() -> Any {
        [
            "editResults": editResults.map {
                $0.toJSONFlutterEx()
            },
            "layerId": layerID,
            "tableName": tableName,
        ]
    }
}