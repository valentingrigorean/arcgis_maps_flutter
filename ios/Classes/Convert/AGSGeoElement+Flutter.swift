//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

extension AGSGeoElement {
    func toJSONFlutter() -> Any {
        let flutterGeometry = try? geometry?.toJSON()
        var flutterAttributes = [String: Any]()

        for attr in attributes {
            let flutterType = getFieldType(value: attr.value)
            var value: Any? = nil
            switch flutterType {
            case .date:
                if let date = attr.value as? Date {
                    value = date.toIso8601String()
                } else if let nsDate = attr.value as? NSDate {
                    value = nsDate.toIso8601String()
                } else {
                    value = nil
                }
                break
            default:
                value = attr.value
                break
            }

            flutterAttributes[attr.key as! String] = [
                "type": flutterType.rawValue,
                "value": value
            ]
        }

        return ["geometry": flutterGeometry, "attributes": flutterAttributes]
    }
}
