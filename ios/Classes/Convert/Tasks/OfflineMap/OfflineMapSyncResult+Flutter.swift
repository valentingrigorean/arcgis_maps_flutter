//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS


extension OfflineMapSyncResult {
    func toJSONFlutter() -> Any {
        [
            "hasErrors": hasErrors,
            "isMobileMapPackageReopenRequired": mobileMapPackageReopenIsRequired,
        ]
    }
}

