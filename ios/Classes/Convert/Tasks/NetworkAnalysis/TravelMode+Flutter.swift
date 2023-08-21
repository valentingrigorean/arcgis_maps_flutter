//
// Created by Valentin Grigorean on 02.02.2022.
//

import Foundation
import ArcGIS

extension TravelMode{

    convenience init(data:Dictionary<String,Any>){
        self.init()
        let attributeParameterValues = (data["attributeParameterValues"] as? [Dictionary<String,Any>])!.map { AttributeParameterValue(data: $0) }
        addAttributeParameterValues(attributeParameterValues)
        description = data["travelModeDescription"] as! String
        distanceAttributeName = data["distanceAttributeName"] as! String
        impedanceAttributeName = data["impedanceAttributeName"] as! String
        name = data["name"] as! String
        outputGeometryPrecision = data["outputGeometryPrecision"] as! Double
        let restrictionAttributeNames = data["restrictionAttributeNames"] as! [String]
        addRestrictionAttributeNames(restrictionAttributeNames)
        timeAttributeName = data["timeAttributeName"] as! String
        self.type = data["type"] as! String
        usesHierarchy = data["useHierarchy"] as! Bool
        uTurnPolicy = TravelMode.UTurnPolicy(data["uTurnPolicy"] as! Int)
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["attributeParameterValues"] = attributeParameterValues.map { $0.toJSONFlutter() }
        json["travelModeDescription" ] = description
        json["distanceAttributeName"] = distanceAttributeName
        json["impedanceAttributeName"] = impedanceAttributeName
        json["name"] = name
        json["outputGeometryPrecision"] = outputGeometryPrecision
        json["restrictionAttributeNames"] = restrictionAttributeNames
        json["timeAttributeName"] = timeAttributeName
        json["type"] = self.type
        json["useHierarchy"] = usesHierarchy
        json["uTurnPolicy"] = uTurnPolicy.toFlutterValue()
        return json
    }
}
