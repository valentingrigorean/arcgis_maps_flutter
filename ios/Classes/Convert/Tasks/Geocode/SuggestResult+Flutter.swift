//
// Created by Valentin Grigorean on 10.12.2022.
//

import Foundation
import ArcGIS

extension SuggestResult {
    func toJSONFlutter(suggestResultId: String) -> Dictionary<String, Any> {
        var result = Dictionary<String, Any>()
        result["label"] = label
        result["isCollection"] = isCollection
        result["suggestResultId"] = suggestResultId
        return result
    }
}
