//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension AGSOfflineMapUpdateCapabilities {
    func toJSONFlutter() -> Any {
        [
            "supportsScheduledUpdatesForFeatures": supportsScheduledUpdatesForFeatures,
            "supportsSyncWithFeatureServices": supportsSyncWithFeatureServices,
        ]
    }
}