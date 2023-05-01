//
// Created by Valentin Grigorean on 31.03.2021.
//

import Foundation

extension Error {
    func toFlutterJson(withStackTrace: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["domain"] = 2
        if let nsError = self as NSError? {
            dict["code"] = nsError.code
            dict["errorMessage"] = nsError.localizedDescription
            dict["additionalMessage"] = nsError.localizedFailureReason
        } else {
            dict["code"] = -1
            dict["errorMessage"] = localizedDescription
        }
        
        if withStackTrace {
            dict["nativeStackTrace"] = Thread.callStackSymbols.joined(separator: "\n")
        }        
        
        return dict
    }
}
