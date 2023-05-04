//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AttributeParameterValue {

    convenience init(data: Dictionary<String, Any>) {
        self.init()
        attributeName = data["attributeName"] as! String
        parameterName = data["parameterName"] as! String
        if let parameterValue = data["parameterValue"] as? Dictionary<String, Any> {
            self.parameterValue = fromFlutterField(data: parameterValue)
        }
    }

    func toJSONFlutter() -> Any {
        [
            "attributeName": attributeName,
            "parameterName": parameterName,
            "parameterValue": toFlutterFieldType(obj: parameterValue)
        ]
    }
}
