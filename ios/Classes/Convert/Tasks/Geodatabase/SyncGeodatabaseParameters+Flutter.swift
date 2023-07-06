//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension SyncGeodatabaseParameters {
    convenience init(data: [String: Any]) {
        self.init()
        keepsGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as! Bool
        geodatabaseSyncDirection = SyncDirection(data["geodatabaseSyncDirection"] as! Int)
        let layersOptions = (data["layerOptions"] as! [[String: Any]]).map {
            SyncLayerOption(data: $0)
        }
        for layerOption in layersOptions {
            addLayerOption(layerOption)
        }
        shouldRollbackOnFailure = data["rollbackOnFailure"] as! Bool
    }

    func toJSONFlutter() -> Any {
        [
            "keepGeodatabaseDeltas": keepsGeodatabaseDeltas,
            "geodatabaseSyncDirection": geodatabaseSyncDirection.toFlutterValue(),
            "layerOptions": layerOptions.map {
                $0.toJSONFlutter()
            },
            "rollbackOnFailure": shouldRollbackOnFailure,
        ] as [String : Any]
    }
}
