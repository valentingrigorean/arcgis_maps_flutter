//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension AGSGeodatabaseDeltaInfo {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()

        if let downloadDeltaFileUrl = downloadDeltaFileURL {
            json["downloadDeltaFileUrl"] = downloadDeltaFileUrl.absoluteString
        }
        json["featureServiceUrl"] = featureServiceURL.absoluteString
        json["geodatabaseFileUrl"] = geodatabaseFileURL.absoluteString
        if let uploadDeltaFileUrl = uploadDeltaFileURL {
            json["uploadDeltaFileUrl"] = uploadDeltaFileUrl.absoluteString
        }

        return json
    }
}