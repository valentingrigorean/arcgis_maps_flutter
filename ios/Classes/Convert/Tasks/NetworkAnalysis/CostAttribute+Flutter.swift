//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension CostAttribute {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["parameterValues"] = parameterValues.toFlutterTypes()
        json["unit"] = unit?.toFlutterValue()
        return json
    }
}
