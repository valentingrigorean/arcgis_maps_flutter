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

extension LinearUnit {
    convenience init?(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self.init(linearID: .centimeters)
            break
        case 1:
            self.init(linearID: .feet)
            break
        case 2:
            self.init(linearID: .inches)
            break
        case 3:
            self.init(linearID: .kilometers)
            break
        case 4:
            self.init(linearID: .meters)
            break
        case 5:
            self.init(linearID: .miles)
            break
        case 6:
            self.init(linearID: .millimeters)
            break
        case 7:
            self.init(linearID: .nauticalMiles)
            break
        case 8:
            self.init(linearID: .yards)
            break
        default:
            return nil
        }
    }

    func toFlutterValue() -> Int {
        switch linearID {
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

extension AngularUnit {
    convenience init?(flutterValue: Int) {
        switch flutterValue {
        case 0:
            self.init(angularID: .degrees)
            break
        case 1:
            self.init(angularID: .minutes)
            break
        case 2:
            self.init(angularID: .seconds)
            break
        case 3:
            self.init(angularID: .grads)
            break
        case 4:
            self.init(angularID: .radians)
            break
        default:
            return nil
        }
    }
}

extension GeometryEngine.GeodeticCurveType {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .geodesic
        case 1:
            self = .loxodrome
        case 2:
            self = .greatElliptic
        case 3:
            self = .normalSection
        case 4:
            self = .shapePreserving
        default:
            fatalError("Unexpected flutter value: \(flutterValue)")
        }
    }
}

extension AreaUnit {
    convenience init?(flutterValue: Int) {
        switch flutterValue {
        case 0:
            self.init(areaID: .acres)
            break
        case 1:
            self.init(areaID: .hectares)
            break
        case 2:
            self.init(areaID: .squareCentimeters)
            break
        case 3:
            self.init(areaID: .squareDecimeters)
            break
        case 4:
            self.init(areaID: .squareFeet)
            break
        case 5:
            self.init(areaID: .squareMeters)
            break
        case 6:
            self.init(areaID: .squareKilometers)
            break
        case 7:
            self.init(areaID: .squareMiles)
            break
        case 8:
            self.init(areaID: .squareMillimeters)
            break
        case 9:
            self.init(areaID: .squareYards)
            break
        default:
            return nil
        }
    }
}

extension CoordinateFormatter.LatitudeLongitudeFormat {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .decimalDegrees
        case 1:
            self = .degreesDecimalMinutes
        case 2:
            self = .degreesMinutesSeconds
        default:
            fatalError("Unexpected flutter value: \(flutterValue)")
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
