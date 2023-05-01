//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

extension GeocodeParameters{
    convenience init(data:Dictionary<String,Any>){
        self.init()
        if let resultAttributeNames = data["resultAttributeNames"] as? [String]{
            for attr in resultAttributeNames{
                addResultAttributeName(attr)
            }
        }
        if let categories = data["categories"] as? [String]{
            for categorie in categories{
                addCategory(categorie)
            }
        }
        if let countryCode = data["countryCode"] as? String{
            self.countryCode = countryCode
        }
        isForStorage = data["forStorage"] as! Bool
        maxResults = data["maxResults"] as! Int
        minScore = data["minScore"] as! Double
        if let outputLanguageCode = data["outputLanguageCode"] as? String{
            self.outputLanguageCode = outputLanguageCode
        }
        if let outputSpatialReference = data["outputSpatialReference"] as? [String:Any]{
            self.outputSpatialReference = SpatialReference(data: outputSpatialReference)
        }
        if let preferredSearchLocation = data["preferredSearchLocation"] as? [String:Any]{
            self.preferredSearchLocation = Point(data: preferredSearchLocation)
        }
        if let searchArea = data["searchArea"] as? [String:Any]{
            self.searchArea = Geometry.fromFlutter(data: searchArea)
        }
    }
}
