//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

extension AGSGenerateLayerOption {
    convenience init(data: Dictionary<String, Any>) {
        self.init(layerID: data["layerId"] as! Int)
        includeRelated = data["includeRelated"] as! Bool
        queryOption = AGSGenerateLayerQueryOption(rawValue: data["queryOption"] as! Int)!
        useGeometry = data["useGeometry"] as! Bool
        whereClause = data["whereClause"] as! String
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["layerId"] = layerID
        json["includeRelated"] = includeRelated
        json["queryOption"] = queryOption.rawValue
        json["useGeometry"] = useGeometry
        json["whereClause"] = whereClause
        return json
    }
}