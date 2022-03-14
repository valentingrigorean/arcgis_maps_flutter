//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSRestrictionAttribute {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["restrictionUsageParameterName"] = restrictionUsageParameterName
        if let parameterValues = parameterValues {
            json["parameterValues"] = parameterValues.toFlutterTypes()
        }
        return json
    }
}