//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension AGSOfflineMapItemInfo {
    func toJSONFlutter() -> Any {
        var data = [
            "accessInformation": accessInformation,
            "itemDescription": itemDescription,
            "snippet": snippet,
            "tags": tags,
            "termsOfUse": termsOfUse,
            "title": title,
        ] as [String: Any]

        if let thumbnail = thumbnail {
            if let bytes = thumbnail.pngData() {
                data["thumbnail"] = FlutterStandardTypedData(bytes: bytes)
            }
        }
        return data
    }
}