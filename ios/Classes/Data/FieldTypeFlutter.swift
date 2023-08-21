//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

enum FieldTypeFlutter: Int, Codable {
    case unknown = 0
    case integer = 1
    case double = 2
    case date = 3
    case text = 4
    case nullable = 5
    case blob = 6
    case geometry = 7
}

func getFieldType(value: Any?) -> FieldTypeFlutter {
    guard let _ = value else {
        return .nullable
    }
    if let _ = value as? String {
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
    } else if let _ = value as? Data {
        return .blob
    } else if let _ = value as? Geometry {
        return .geometry
    } else if let _ = value as? NSNull {
        return .nullable
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
    case .geometry:
        if let geometry = obj as? Geometry {
            value = geometry.toJSONFlutter()
        } else {
            value = nil
        }
        break
    case .blob:
        if let bytes = obj as? Data {
            value = FlutterStandardTypedData(bytes: bytes)
        } else {
            value = nil
        }
        break
    case .unknown:
        value = nil
        break
    case .integer:
        if let number = obj as? NSNumber {
            value = number.intValue
        } else {
            value = obj
        }
        break
    case .double:
        if let number = obj as? NSNumber {
            value = number.doubleValue
        } else {
            value = obj
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

func fromFlutterField(data: [String: Any]) -> Any? {
    let type = FieldTypeFlutter(rawValue: data["type"] as! Int)!
    var value = data["value"]
    switch type {
    case .date:
        if let date = value as? String {
            value = date.toDateFromIso8601()
        }
        break
    case .geometry:
        if let geometry = value as? [String: Any] {
            value = Geometry.fromFlutter(data: geometry)
        }
        break
    case .blob:
        if let bytes = value as? FlutterStandardTypedData {
            value = bytes.data
        }
        break
    case .integer:
        if let number = value as? NSNumber {
            value = number.intValue
        }
        break
    case .double:
        if let number = value as? NSNumber {
            value = number.doubleValue
        }
        break
    default:
        break
    }
    return value
}
