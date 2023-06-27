//
// Created by Valentin Grigorean on 08.11.2021.
//

import Foundation
import ArcGIS

enum GeometryType: Int, Hashable {
    case point = 1
    case envelope = 2
    case polyline = 3
    case polygon = 4
    case multipoint = 5
    case unknown = -1
}

extension LinearUnit.ID {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .centimeters
        case 1:
            self = .feet
        case 2:
            self = .inches
        case 3:
            self = .kilometers
        case 4:
            self = .meters
        case 5:
            self = .miles
        case 6:
            self = .nauticalMiles
        case 7:
            self = .yards
        default:
            fatalError("Unexpected flutter value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .centimeters:
            return 0
        case .feet:
            return 1
        case .inches:
            return 2
        case .kilometers:
            return 3
        case .meters:
            return 4
        case .miles:
            return 5
        case .nauticalMiles:
            return 6
        case .yards:
            return 7
        default:
            return 8
        }
    }
}

extension Geometry {
    static func fromFlutter(data: Dictionary<String, Any>) -> Geometry? {
        guard let geometryType = data["type"] as? Int,
              let geometryType = GeometryType(rawValue: geometryType)
        else {
            return tryParseAsJson(data: data)
        }
        switch (geometryType) {
        case .point:
            return Point(data: data)
        case .envelope:
            return Envelope(data: data)
        case .polyline, .polygon, .multipoint:
            return tryParseAsJson(data: data)
        case .unknown:
            return nil
        @unknown default:
            return nil
        }
    }

    func toJSONFlutter() -> Any? {
        do {
            guard let data = toJSON().data(using: .utf8) else {
                return nil
            }
            if var dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                dictionary["type"] = geometryType()
                return dictionary
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
            return nil
        }
        return nil
    }


    private static func tryParseAsJson(data: Dictionary<String, Any>) -> Geometry? {
        do {
            // Convert the dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
            // Convert the JSON data to a JSON string
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                print("Could not convert data to UTF-8 encoded string")
                return nil
            }
            // Convert the JSON data to a Geometry
            let geometry = try Geometry.fromJSON(jsonString)
            return geometry
        } catch let error {
            print("Error parsing JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Geometry {
    func geometryType() -> GeometryType {
        switch self {
        case is Point:
            return .point
        case is Envelope:
            return .envelope
        case is Polyline:
            return .polyline
        case is Polygon:
            return .polygon
        case is Multipoint:
            return .multipoint
        default:
            return .unknown
        }
    }
}
