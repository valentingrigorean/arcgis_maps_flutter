//
// Created by Valentin Grigorean on 04.06.2021.
//

import Foundation
import ArcGIS

extension PortalItem {
    convenience init(data: [String: Any]) {
        let portal = Portal(data: data["portal"] as! [String: Any])
        let itemId = data["itemId"] as! String
        self.init(portal: portal, id: ID(itemId)!)
    }
}