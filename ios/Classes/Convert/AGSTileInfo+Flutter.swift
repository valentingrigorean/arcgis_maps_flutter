//
// Created by Valentin Grigorean on 14.09.2021.
//

import Foundation
import ArcGIS

extension AGSTileInfo {
    convenience init(data: Dictionary<String, Any>) {
        let dpi = data["dpi"] as! Int
        let imageFormat = data["imageFormat"] as! Int
        let levelOfDetails = (data["levelOfDetails"] as! [Any]).map {
            AGSLevelOfDetail(data: $0 as! [Any])
        }

        let origin = AGSPoint(data: data["origin"] as! Dictionary<String, Any>)
        let spatialReference = AGSSpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
        let tileHeight = data["tileHeight"] as! Int
        let tileWidth = data["tileWidth"] as! Int

        self.init(dpi: dpi, format: AGSTileImageFormat(rawValue: imageFormat) ?? .unknown, levelsOfDetail: levelOfDetails, origin: origin, spatialReference: spatialReference, tileHeight: tileHeight, tileWidth: tileWidth)
    }

    func toJSONFlutter() -> Dictionary<String, Any> {
        [
            "dpi": dpi,
            "imageFormat": format.rawValue,
            "levelOfDetails": levelsOfDetail.map { $0.toJSONFlutter() },
            "origin": origin.toJSONFlutter(),
            "spatialReference": spatialReference.toJSONFlutter(),
            "tileHeight": tileHeight,
            "tileWidth": tileWidth
        ]
    }
}