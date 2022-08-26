//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension AGSEditResult {
    func toJSONFlutter() -> Any {
        [
            "completedWithErrors": completedWithErrors,
            "editOperation": editOperation.rawValue,
            "error": error?.toJSON(),
            "globalId": globalID,
            "objectId": objectID,
        ]
    }
}

extension AGSFeatureEditResult {
    func toJSONFlutterEx() -> Any {
        [
            "completedWithErrors": completedWithErrors,
            "editOperation": editOperation.rawValue,
            "error": error?.toJSON(),
            "globalId": globalID,
            "objectId": objectID,
            "attachmentResults": attachmentResults.map {
                $0.toJSONFlutter()
            },
        ]
    }
}