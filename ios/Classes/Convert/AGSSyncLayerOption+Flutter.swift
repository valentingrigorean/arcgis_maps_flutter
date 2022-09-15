//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension AGSSyncLayerOption {

    convenience init(data:Dictionary<String,Any>){
        self.init()
        layerID = data["layerId"] as! Int
        syncDirection = AGSSyncDirection(rawValue: data["syncDirection"] as! Int)!
    }

    func toJSONFlutter() -> [String: Any] {
        [
            "layerId": layerID,
            "syncDirection": syncDirection.rawValue,
        ]
    }
}