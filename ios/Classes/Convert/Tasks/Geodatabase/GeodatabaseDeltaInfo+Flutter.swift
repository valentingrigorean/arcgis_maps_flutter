//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

extension GeodatabaseDeltaInfo {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()

        if let downloadDeltaFileUrl = downloadDeltaURL {
            json["downloadDeltaFileUrl"] = downloadDeltaFileUrl.absoluteString
        }
        json["featureServiceUrl"] = featureServiceURL.absoluteString
        json["geodatabaseFileUrl"] = geodatabaseURL.absoluteString
        if let uploadDeltaFileUrl = uploadDeltaURL {
            json["uploadDeltaFileUrl"] = uploadDeltaFileUrl.absoluteString
        }

        return json
    }
}
