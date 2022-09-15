//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

extension AGSExportTileCacheParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        if let geometry = data["geometry"] as? Dictionary<String, Any> {
            areaOfInterest = AGSGeometry.fromFlutter(data: geometry)
        }
        compressionQuality = data["compressionQuality"] as! Float
        levelIDs = (data["levelIds"] as! [Int]).map({ NSNumber(value: $0) })
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let areaOfInterest = areaOfInterest {
            json["areaOfInterest"] = areaOfInterest.toJSONFlutter()
        }
        json["compressionQuality"] = compressionQuality
        json["levelIds"] = levelIDs.map({ $0.intValue })
        return json
    }
}
