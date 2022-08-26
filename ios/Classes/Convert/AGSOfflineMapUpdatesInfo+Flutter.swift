//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension AGSOfflineMapUpdatesInfo {
    func toJSONFlutter() -> [String: Any] {
        [
            "downloadAvailability": downloadAvailability.rawValue,
            "isMobileMapPackageReopenRequired": isMobileMapPackageReopenRequired,
            "scheduledUpdatesDownloadSize": scheduledUpdatesDownloadSize,
            "uploadAvailability": uploadAvailability.rawValue,
        ]
    }
}