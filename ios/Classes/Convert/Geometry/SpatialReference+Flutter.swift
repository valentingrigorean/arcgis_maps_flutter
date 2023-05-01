//
// Created by Valentin Grigorean on 14.04.2021.
//

import Foundation
import ArcGIS

extension SpatialReference {
    convenience init?(data: Dictionary<String, Any>) {
        if let wkId = data["wkid"] as? Int {
            self.init(wkid: wkId)
            return
        }
        if let wkText = data["wkText"] as? String {
            self.init(wkText: wkText)
            return
        }

        fatalError("Not implemented")
    }

    func toJSONFlutter() -> Any {
        [
            "wkid": wkid,
            "wkText": wkText
        ]
    }
}
