//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension RouteResult {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["directionsLanguage"] = directionsLanguage
        json["messages"] = messages
        json["routes"] = routes.map { $0.toJSONFlutter() }
        return json
    }
}
