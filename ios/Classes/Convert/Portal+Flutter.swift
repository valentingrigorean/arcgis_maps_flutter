//
// Created by Valentin Grigorean on 04.06.2021.
//

import Foundation
import ArcGIS

extension Portal {
    convenience init(data: Dictionary<String, Any>) {
        let postalUrl = data["url"] as! String
        self.init(url: URL(string: postalUrl)!, connection: toConnection(value: data["connection"] as? Int))
    }
}

private func toConnection(value: Int?) -> Portal.Connection {
    guard let value else {
        return Portal.Connection.anonymous
    }
    switch value {
    case 0:
        return Portal.Connection.anonymous
    case 1:
        return Portal.Connection.authenticated
    default:
        return Portal.Connection.anonymous
    }
}
