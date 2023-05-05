//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension OfflineMapSyncParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        keepsGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as! Bool
        preplannedScheduledUpdatesOption = PreplannedScheduledUpdatesOption.fromFlutter( data["preplannedScheduledUpdatesOption"] as! Int)
        shouldRollbackOnFailure = data["rollbackOnFailure"] as! Bool
        syncDirection = SyncDirection.fromFlutter(data["syncDirection"] as! Int)
    }

    func toJSONFlutter() -> Any {
        [
            "keepGeodatabaseDeltas": keepsGeodatabaseDeltas,
            "preplannedScheduledUpdatesOption": preplannedScheduledUpdatesOption.toFlutterValue(),
            "rollbackOnFailure": shouldRollbackOnFailure,
            "syncDirection": syncDirection.toFlutterValue(),
        ] as [String:Any]
    }
}
