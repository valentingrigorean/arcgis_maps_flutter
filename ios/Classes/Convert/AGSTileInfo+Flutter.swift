//
// Created by Valentin Grigorean on 14.09.2021.
//

import Foundation
import ArcGIS


extension TileImageFormat {
    func toFlutterValue() -> Int {
        switch self {
        case .png:
            return 0
        case .png8:
            return 1
        case .png24:
            return 2
        case .png32:
            return 3
        case .jpg:
            return 4
        case .mixed:
            return 5
        case .lerc:
            return 6
        }
    }

    static func fromFlutter(_ flutterValue: Int) -> TileImageFormat {
        switch flutterValue {
        case 0:
            return .png
        case 1:
            return .png8
        case 2:
            return .png24
        case 3:
            return .png32
        case 4:
            return .jpg
        case 5:
            return .mixed
        case 6:
            return .lerc
        case 7:
            return .png
        default:
            fatalError("Invalid TileImageFormat value \(self)")
        }
    }
}

extension TileInfo {
    convenience init(data: Dictionary<String, Any>) {
        let dpi = data["dpi"] as! Int
        let imageFormat = data["imageFormat"] as! Int
        let levelOfDetails = (data["levelOfDetails"] as! [Any]).map {
            LevelOfDetail(data: $0 as! [Any])
        }

        let origin = Point(data: data["origin"] as! Dictionary<String, Any>)
        let spatialReference = SpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
        let tileHeight = data["tileHeight"] as! Int
        let tileWidth = data["tileWidth"] as! Int

        self.init(dpi: dpi, format: TileImageFormat.fromFlutter(imageFormat), levelsOfDetail: levelOfDetails, origin: origin, spatialReference: spatialReference, tileHeight: tileHeight, tileWidth: tileWidth)
    }

    func toJSONFlutter() -> Dictionary<String, Any> {
        [
            "dpi": dpi,
            "imageFormat": format.toFlutterValue(),
            "levelOfDetails": levelsOfDetail.map {
                $0.toJSONFlutter()
            },
            "origin": origin.toJSONFlutter(),
            "spatialReference": spatialReference.toJSONFlutter(),
            "tileHeight": tileHeight,
            "tileWidth": tileWidth
        ]
    }
}
