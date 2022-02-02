//
// Created by Valentin Grigorean on 04.06.2021.
//

import Foundation
import ArcGIS

extension AGSPortal {
    convenience init(data: Dictionary<String, Any>) {
        let postalUrl = data["postalUrl"] as! String
        let loginRequired = data["loginRequired"] as! Bool
        self.init(url: URL(string: postalUrl) as! URL, loginRequired: loginRequired)
        if let rawCredentials = data["credential"] as? Dictionary<String, Any> {
            credential = AGSCredential(data: rawCredentials)
        }
    }
}