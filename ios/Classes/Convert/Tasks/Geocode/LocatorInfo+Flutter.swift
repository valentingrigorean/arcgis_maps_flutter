//
// Created by Valentin Grigorean on 10.11.2021.
//

import Foundation
import ArcGIS

extension LocatorInfo {
    func toJSONFlutter() -> Any {
        var data = [String: Any]()
        data["name"] = name
        data["description"] = description
        data["intersectionResultAttributes"] = intersectionResultAttributes.map {
            $0.toJSONFlutter()
        }

       
        data["properties"] = properties
        

        data["resultAttributes"] = resultAttributes.map {
            $0.toJSONFlutter()
        }
        data["searchAttributes"] = searchAttributes.map {
            $0.toJSONFlutter()
        }

        if let spatialReference = spatialReference {
            data["spatialReference"] = spatialReference.toJSONFlutter()
        }

        data["supportsPOI"] = supportsPOI
        data["supportsAddresses"] = supportsAddresses
        data["supportsIntersections"] = supportsIntersections
        data["supportsSuggestions"] = supportsSuggestions
        data["version"] = version

        return data
    }
}

extension LocatorAttribute {
    func toJSONFlutter() -> Any {
        var data = [String: Any]()
        data["name"] = name
        data["displayName"] = displayName
        data["required"] = isRequired
        return data
    }
}
