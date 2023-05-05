//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension OfflineMapUpdatesInfo {
    func toJSONFlutter() -> [String: Any] {
        [
            "downloadAvailability": downloadAvailability.toFlutterValue(),
            "isMobileMapPackageReopenRequired": mobileMapPackageReopenIsRequired,
            "scheduledUpdatesDownloadSize": scheduledUpdatesDownloadSize,
            "uploadAvailability": uploadAvailability.toFlutterValue(),
        ]
    }
}
