//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS


extension AGSOfflineMapSyncResult {
    func toJSONFlutter() -> Any {
        [
            "hasErrors": hasErrors,
            "isMobileMapPackageReopenRequired": isMobileMapPackageReopenRequired,
        ]
    }
}

