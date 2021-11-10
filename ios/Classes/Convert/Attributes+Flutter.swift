//
// Created by Valentin Grigorean on 09.11.2021.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func toFlutterTypes() -> Dictionary<String, Any> {
        var flutterAttributes = [String: Any]()

        for attr in self {
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

            flutterAttributes[attr.key] = [
                "type": flutterType.rawValue,
                "value": value
            ]
        }
        return flutterAttributes
    }
}

extension NSMutableDictionary{
    func toFlutterTypes() -> Dictionary<String, Any> {
        var flutterAttributes = [String: Any]()

        for attr in self {
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
        return flutterAttributes
    }
}