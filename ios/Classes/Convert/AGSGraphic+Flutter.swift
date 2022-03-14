//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

extension AGSGraphic {
    convenience init(data: Dictionary<String, Any>) {
        let markerId = data["markerId"] as! String
        self.init(geometry: nil, symbol: nil, attributes: ["markerId": markerId])
    }
}