//
// Created by Valentin Grigorean on 10.12.2022.
//

import Foundation
import ArcGIS

extension SuggestParameters{
    convenience init(data:Dictionary<String,Any>){
        self.init()
        if let categories = data["categories"] as? [String]{
            for categorie in categories{
                addCategory(categorie)
            }
        }
        countryCode = data["countryCode"] as! String
        maxResults = data["maxResults"] as! Int
        if let preferredSearchLocation = data["preferredSearchLocation"] as? Dictionary<String,Any>{
            self.preferredSearchLocation = Point(data: preferredSearchLocation)
        }
        if let searchArea = data["searchArea"] as? Dictionary<String,Any>{
            self.searchArea = Geometry.fromFlutter(data: searchArea)
        }
    }
}
