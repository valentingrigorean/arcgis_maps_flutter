//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension OfflineMapItemInfo {
    convenience init(data: [String: Any]) {
        self.init()
        accessInformation = data["accessInformation"] as! String
        description = data["itemDescription"] as! String
        snippet = data["snippet"] as! String
        addTags(data["tags"] as! [String])
        termsOfUse = data["termsOfUse"] as! String
        title = data["title"] as! String
        if let thumbnail = data["thumbnail"] as? FlutterStandardTypedData {
            self.thumbnail = UIImage(data: thumbnail.data)
        }
    }

    func toJSONFlutter() -> Any {
        var data = [
            "accessInformation": accessInformation,
            "itemDescription": description,
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
