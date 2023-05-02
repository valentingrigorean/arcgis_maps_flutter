//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

extension EditOperation{
    func toFlutterValue() -> Int{
        switch self{
        case .add:
            return 0
        case .update:
            return 1
        case .delete:
            return 2
        default:
            return -1
        }
    }
}

extension EditResult {
    func toJSONFlutter() -> Any {
        var json = [
            "completedWithErrors": didCompleteWithErrors,
            "editOperation": operation?.toFlutterValue() ?? -1,
            "globalId": globalID,
            "objectId": objectID,
        ] as [String : Any]
        if(error != nil){
            json["error"] = error!.toJSONFlutter(withStackTrace: false)
        }
        return json
    }
}

extension FeatureEditResult {
    func toJSONFlutterEx() -> Any {
        var json = [
            "completedWithErrors": didCompleteWithErrors,
            "editOperation": operation?.toFlutterValue() ?? -1,
            "globalId": globalID,
            "objectId": objectID,
            "attachmentResults": attachmentResults.map{ $0.toJSONFlutter()}
        ] as [String : Any]
        if(error != nil){
            json["error"] = error!.toJSONFlutter(withStackTrace: false)
        }
        return json
    }
}
