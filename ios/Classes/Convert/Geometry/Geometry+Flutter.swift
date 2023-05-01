//
// Created by Valentin Grigorean on 08.11.2021.
//

import Foundation
import ArcGIS

enum GeometryType : Int,Hashable{
    case point = 1
    case envelope = 2
    case polyline = 3
    case polygon = 4
    case multipoint = 5
    
}

extension Geometry {
    static func fromFlutter(data: Dictionary<String, Any>) -> Geometry? {
        let geometryType = GeometryType(rawValue: data["type"] as! Int)!
        switch (geometryType) {
        case .point:
            return Point(data: data)
        case .envelope:
            return Envelope(data: data)
        case .polyline, .polygon, .multipoint:
            do {
                let geometry = try Geometry.fromJSON(data)
                return geometry as? Geometry
            } catch let error {
                fatalError("\(error)")
            }
        @unknown default:
            return nil
        }
    }

    func toJSONFlutter() -> Any? {
        do {
            let json = try toJSON()
            if var dict = json as? Dictionary<String, Any> {
                dict["type"] = geometryType.rawValue
                return dict
            }
            return json
        } catch let error {
            return nil
        }
    }
}

