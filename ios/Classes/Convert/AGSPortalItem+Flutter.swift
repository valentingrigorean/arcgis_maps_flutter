//
// Created by Valentin Grigorean on 04.06.2021.
//

import Foundation
import ArcGIS

extension AGSPortalItem {
    convenience init(data: Dictionary<String, Any>) {
        let portal = AGSPortal(data: data["portal"] as! Dictionary<String, Any>)
        let itemId = data["itemId"] as! String
        self.init(portal: portal, itemID: itemId)
    }
}