//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension AGSTravelMode{

    convenience init(data:Dictionary<String,Any>){
        self.init()
        attributeParameterValues = (data["attributeParameterValues"] as? [Dictionary<String,Any>])!.map { AGSAttributeParameterValue(data: $0) }
        travelModeDescription = data["travelModeDescription"] as! String
        distanceAttributeName = data["distanceAttributeName"] as! String
        impedanceAttributeName = data["impedanceAttributeName"] as! String
        name = data["name"] as! String
        outputGeometryPrecision = data["outputGeometryPrecision"] as! Double
        restrictionAttributeNames = data["restrictionAttributeNames"] as! [String]
        timeAttributeName = data["timeAttributeName"] as! String
        type = data["type"] as! String
        useHierarchy = data["useHierarchy"] as! Bool
        uTurnPolicy = AGSUTurnPolicy(rawValue: data["uTurnPolicy"] as! Int)!
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["attributeParameterValues"] = attributeParameterValues.map { $0.toJSONFlutter() }
        json["travelModeDescription" ] = travelModeDescription
        json["distanceAttributeName"] = distanceAttributeName
        json["impedanceAttributeName"] = impedanceAttributeName
        json["name"] = name
        json["outputGeometryPrecision"] = outputGeometryPrecision
        json["restrictionAttributeNames"] = restrictionAttributeNames
        json["timeAttributeName"] = timeAttributeName
        json["type"] = type
        json["useHierarchy"] = useHierarchy
        json["uTurnPolicy"] = uTurnPolicy.rawValue
        return json
    }
}