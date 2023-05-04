//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension RestrictionAttribute {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["restrictionUsageParameterName"] = restrictionUsageParameterName
        json["parameterValues"] = parameterValues.toFlutterTypes()
        return json
    }
}
