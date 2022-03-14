//
// Created by Valentin Grigorean on 31.03.2021.
//

import Foundation

extension Error {
    func toJSON() -> Dictionary<String, Any> {
        ["code": -1, "message": localizedDescription]
    }
}
