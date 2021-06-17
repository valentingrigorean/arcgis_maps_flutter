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
                let format = ISO8601DateFormatter()
                if let date = attr.value as? Date {
                    value = format.string(from: date)
                } else if let nsDate = attr.value as? NSDate {
                    value = format.string(from: nsDate as Date)
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
