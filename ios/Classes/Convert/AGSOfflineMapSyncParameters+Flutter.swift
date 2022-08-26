//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension AGSOfflineMapSyncParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        keepGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as! Bool
        preplannedScheduledUpdatesOption = AGSPreplannedScheduledUpdatesOption(rawValue: data["preplannedScheduledUpdatesOption"] as! Int)!
        rollbackOnFailure = data["rollbackOnFailure"] as! Bool
        syncDirection = AGSSyncDirection(rawValue: data["syncDirection"] as! Int)!
    }

    func toJSONFlutter() -> Any {
        [
            "keepGeodatabaseDeltas": keepGeodatabaseDeltas,
            "preplannedScheduledUpdatesOption": preplannedScheduledUpdatesOption.rawValue,
            "rollbackOnFailure": rollbackOnFailure,
            "syncDirection": syncDirection.rawValue,
        ]
    }
}