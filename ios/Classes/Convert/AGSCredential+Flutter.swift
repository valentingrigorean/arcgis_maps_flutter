//
// Created by Valentin Grigorean on 31.03.2021.
//

import Foundation
import ArcGIS

extension AGSCredential {
    convenience init(data: Dictionary<String, Any>) {

        let type = data["type"] as! String

        switch type {
        case "UserCredential":
            let referer = data["referer"] as? String
            if let token = data["token"] as? String {
                self.init(token: token, referer: referer)
                return
            }
            let username = data["username"] as! String
            let password = data["password"] as! String
            self.init(user: username, password: password)
            break
        default:
            fatalError("Not implemented.")
            break
        }

    }

    func toJSONFlutter() -> Any {
        [
            "type": "UserCredential",
            "username": username,
            "password": password,
            "referer": referer,
            "token": token
        ]
    }
}