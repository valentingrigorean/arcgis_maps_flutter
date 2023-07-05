//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

extension GenerateLayerOption {
    convenience init(data: Dictionary<String, Any>) {
        self.init(layerID: data["layerId"] as! Int)
        includesRelated = data["includeRelated"] as! Bool
        queryOption = GenerateLayerOption.QueryOption(data["queryOption"] as! Int)
        usesGeometry = data["useGeometry"] as! Bool
        whereClause = data["whereClause"] as! String
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["layerId"] = layerID
        json["includeRelated"] = includesRelated
        json["queryOption"] = queryOption.toFlutterValue()
        json["useGeometry"] = usesGeometry
        json["whereClause"] = whereClause
        return json
    }
}
