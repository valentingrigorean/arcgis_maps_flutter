//
// Created by Valentin Grigorean on 14.04.2021.
//

import Foundation
import ArcGIS

extension SpatialReference {
    init?(data: [String: Any]) {
        if let wkId = data["wkid"] as? Int {
            self.init(wkid: WKID(rawValue: wkId)!)
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
            "wkid": wkid?.rawValue,
            "wkText": wkText
        ]
    }
}
