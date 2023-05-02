//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension SyncLayerResult {
    func toJSONFlutter() -> Any {
        var json = [
            "editResults": editResults.map {
                $0.toJSONFlutterEx()
            },            
            "tableName": tableName,
        ] as [String:Any]
        
        if let layerID = layerID{
            json["layerId"] = layerID
        }
        return json
    }
}
