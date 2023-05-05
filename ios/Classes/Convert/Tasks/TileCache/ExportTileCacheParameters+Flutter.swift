//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

extension ExportTileCacheParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        if let geometry = data["geometry"] as? Dictionary<String, Any> {
            areaOfInterest = Geometry.fromFlutter(data: geometry)
        }
        compressionQuality = data["compressionQuality"] as! Float
        addLevelIDs(data["levelIds"] as! [Int])
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let areaOfInterest = areaOfInterest {
            json["areaOfInterest"] = areaOfInterest.toJSONFlutter()
        }
        json["compressionQuality"] = compressionQuality
        json["levelIds"] = levelIDs
        return json
    }
}
