//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension CostAttribute {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        if let parameterValues = parameterValues {
            json["parameterValues"] = parameterValues.toFlutterTypes()
        }
        json["unit"] = unit.rawValue
        return json
    }
}
