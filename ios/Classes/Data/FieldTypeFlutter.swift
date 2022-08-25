//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation

enum FieldTypeFlutter: Int, Codable {
    case unknown = 0
    case integer = 1
    case double = 2
    case date = 3
    case text = 4
    case nullable = 5
}

func getFieldType(value: Any?) -> FieldTypeFlutter {
    guard let value = value else {
        return .nullable
    }
    if let _ = value as? NSNull {
        return .nullable
    } else if let _ = value as? String {
        return .text
    } else if let _ = value as? Int {
        return .integer
    } else if let _ = value as? Float {
        return .double
    } else if let _ = value as? Double {
        return .double
    } else if let number = value as? NSNumber {
        switch number.type {
        case .floatType, .float32Type, .float64Type, .cgFloatType, .doubleType:
            return .double
        case .intType, .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .cfIndexType, .nsIntegerType, .shortType, .longType, .longLongType, .charType:
            return .integer
        @unknown default:
            return .unknown
        }
    } else if let _ = value as? Date {
        return .date
    } else if let _ = value as? NSData {
        return .date
    } else if let _ = value as? UUID {
        return .text
    }
    return .unknown
}

func toFlutterFieldType(obj: Any?) -> Any {
    let flutterType = getFieldType(value: obj)
    var value: Any? = nil

    switch flutterType {
    case .date:
        if let date = obj as? Date {
            value = date.toIso8601String()
        } else if let nsDate = obj as? NSDate {
            value = nsDate.toIso8601String()
        } else {
            value = nil
        }
        break
    default:
        if let obj = obj as? UUID {
            value = obj.uuidString
        } else {
            value = obj
        }
        break
    }


    return [
        "type": flutterType.rawValue,
        "value": value
    ]
}

func fromFlutterField(data: Dictionary<String, Any>) -> Any? {
    let type = FieldTypeFlutter(rawValue: data["type"] as! Int)!
    var value = data["value"]
    switch type {
    case .date:
        if let date = value as? String {
            value = date.toDateFromIso8601()
        }
        break
    default:
        break
    }
    return value
}