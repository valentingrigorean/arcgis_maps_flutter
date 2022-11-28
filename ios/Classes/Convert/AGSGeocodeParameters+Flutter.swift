//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

extension AGSGeocodeParameters{
    convenience init(data:Dictionary<String,Any>){
        self.init()
        if let resultAttributeNames = data["resultAttributeNames"] as? [String]{
            self.resultAttributeNames = resultAttributeNames
        }
        if let categories = data["categories"] as? [String]{
            self.categories = categories
        }
        if let countryCode = data["countryCode"] as? String{
            self.countryCode = countryCode
        }
        forStorage = data["forStorage"] as! Bool
        maxResults = data["maxResults"] as! Int
        minScore = data["minScore"] as! Double
        if let outputLanguageCode = data["outputLanguageCode"] as? String{
            self.outputLanguageCode = outputLanguageCode
        }
        if let outputSpatialReference = data["outputSpatialReference"] as? [String:Any]{
            self.outputSpatialReference = AGSSpatialReference(data: outputSpatialReference)
        }
        if let preferredSearchLocation = data["preferredSearchLocation"] as? [String:Any]{
            self.preferredSearchLocation = AGSPoint(data: preferredSearchLocation)
        }
        if let searchArea = data["searchArea"] as? [String:Any]{
            self.searchArea = AGSGeometry.fromFlutter(data: searchArea)
        }
    }
}