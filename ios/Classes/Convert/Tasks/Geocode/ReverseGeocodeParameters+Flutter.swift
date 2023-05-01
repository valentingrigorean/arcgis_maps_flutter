//
// Created by Valentin Grigorean on 10.12.2022.
//

import Foundation
import ArcGIS

extension AGSReverseGeocodeParameters{
    convenience init(data:Dictionary<String,Any>){
        self.init()
        if let resultAttributeNames = data["resultAttributeNames"] as? [String]{
            self.resultAttributeNames = resultAttributeNames
        }
        if let featureTypes = data["featureTypes"] as? [String]{
            self.featureTypes = featureTypes
        }
        forStorage = data["forStorage"] as! Bool
        maxDistance = data["maxDistance"] as! Double
        maxResults = data["maxResults"] as! Int
        if let outputSpatialReference = data["outputSpatialReference"] as? Dictionary<String,Any>{
            self.outputSpatialReference = AGSSpatialReference(data: outputSpatialReference)
        }
        outputLanguageCode = data["outputLanguageCode"] as! String
    }
}