//
// Created by Valentin Grigorean on 10.12.2022.
//

import Foundation
import ArcGIS

extension ReverseGeocodeParameters{
    convenience init(data:Dictionary<String,Any>){
        self.init()
        if let resultAttributeNames = data["resultAttributeNames"] as? [String]{
            for attr in resultAttributeNames{
                addResultAttributeName(attr)
            }
        }
        if let featureTypes = data["featureTypes"] as? [String]{
            for featureType in featureTypes{
                addFeatureType(featureType)
            }
        }
        isForStorage = data["forStorage"] as! Bool
        maxDistance = data["maxDistance"] as? Double
        maxResults = data["maxResults"] as! Int
        if let outputSpatialReference = data["outputSpatialReference"] as? Dictionary<String,Any>{
            self.outputSpatialReference = SpatialReference(data: outputSpatialReference)
        }
        outputLanguageCode = data["outputLanguageCode"] as! String
    }
}
