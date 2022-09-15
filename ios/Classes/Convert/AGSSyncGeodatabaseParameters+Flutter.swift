//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension AGSSyncGeodatabaseParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        keepGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as! Bool
        geodatabaseSyncDirection = AGSSyncDirection(rawValue: data["geodatabaseSyncDirection"] as! Int)!
        layerOptions = (data["layerOptions"] as! [Dictionary<String, Any>]).map {
            AGSSyncLayerOption(data: $0)
        }
        rollbackOnFailure = data["rollbackOnFailure"] as! Bool
    }

    func toJSONFlutter() -> Any {
        [
            "keepGeodatabaseDeltas": keepGeodatabaseDeltas,
            "geodatabaseSyncDirection": geodatabaseSyncDirection.rawValue,
            "layerOptions": layerOptions.map {
                $0.toJSONFlutter()
            },
            "rollbackOnFailure": rollbackOnFailure,
        ]
    }
}