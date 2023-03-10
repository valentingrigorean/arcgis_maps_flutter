//
// Created by Mo on 2022/7/23.
//

import Foundation
import Foundation
import ArcGIS

extension AGSFeature {
    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["geometry"] = geometry?.toJSONFlutter()

        var featureTableMap: Dictionary<String, Any> = [:];
        featureTableMap["displayName"] = featureTable?.displayName
        featureTableMap["tableName"] = featureTable?.tableName

        var fields: [Dictionary<String, Any>] = []
        if let f = featureTable?.fields {
            f.forEach { field in
                fields.append([
                    "alias": field.alias,
                    "fieldType": field.type.toFlutterType(),
                    "name": field.name
                ])
            }
        }

        var featureTypesList: [Dictionary<String, Any>] = []
        if let agft = self.featureTable as? AGSArcGISFeatureTable {
//            agf.featureTable?.feature
            agft.featureTypes.forEach { type in
                var map: Dictionary<String, Any> = [:];
                if (type.typeID is Int || type.typeID is Int16 || type.typeID is Int32 || type.typeID is Double || type.typeID is Float) {
                    map["id"] = type.typeID
                    map["name"] = type.name
                    featureTypesList.append(map)
                }
            }
        }

        featureTableMap["featureTypes"] = featureTypesList
        json["featureTable"] = featureTableMap

        var attributesMap: Dictionary<String, Any> = [:]
        attributes.forEach { key, value in
            let f = featureTable?.fields.first(where: { (agsf: AGSField) -> Bool in
                if let k = key as? String {
                    return k == agsf.name
                } else {
                    return false
                }
            })
            switch (f?.type) {

            case .unknown:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .int16:
                if let k = key as? String {
                    attributesMap[k] = value as? Int16
                }
            case .int32:
                if let k = key as? String {
                    attributesMap[k] = value as? Int32
                }
            case .GUID:
                if let k = key as? String {
                    attributesMap[k] = (value as? UUID)?.uuidString
                }
            case .float:
                if let k = key as? String {
                    attributesMap[k] = value as? Float
                }
            case .double:
                if let k = key as? String {
                    attributesMap[k] = value as? Double
                }
            case .date:
                if let k = key as? String {
                    attributesMap[k] = (value as? Date)?.timeIntervalSince1970
                }
            case .text:
                if let k = key as? String {
                    attributesMap[k] = value as? String
                }
            case .OID:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
            case .globalID:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .blob:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .geometry:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .raster:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .XML:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            case .none:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            @unknown default:
                if let k = key as? String {
                    attributesMap[k] = nil
                }
                break
            }

        }

        json["attributes"] = attributesMap

        return json
    }
}

extension AGSFieldType {
    func toFlutterType() -> String {
        switch self {

        case .unknown:
            return "unknown"
        case .int16:
            return "number"
        case .int32:
            return "number"
        case .GUID:
            return "ignore"
        case .float:
            return "number"
        case .double:
            return "number"
        case .date:
            return "date"
        case .text:
            return "text"
        case .OID:
            return "text"
        case .globalID:
            return "oid"
        case .blob:
            return "ignore"
        case .geometry:
            return "ignore"
        case .raster:
            return "ignore"
        case .XML:
            return "ignore"
        @unknown default:
            return "ignore"
        }
    }
}
