//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension SyncLayerOption {
    
    convenience init(data:Dictionary<String,Any>){
        self.init()
        layerID = data["layerId"] as! Int
        syncDirection = SyncDirection.fromFlutter(flutterValue: data["syncDirection"] as! Int)
    }
    
    func toJSONFlutter() -> Any {
        [
            "layerId": layerID,
            "syncDirection": syncDirection.toFlutterValue(),
        ]  as [String : Any]
    }
}
