//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ApiKeyResourceNativeHandler: BaseNativeHandler<AGSAPIKeyResource> {

    init(apiKeyResource: AGSAPIKeyResource) {
        super.init(nativeHandler: apiKeyResource)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "apiKeyResource#getApiKey":
            result(nativeHandler.apiKey)
            return true
        case "apiKeyResource#setApiKey":
            if let apiKey = arguments as? String {
                nativeHandler.apiKey = apiKey
            }
            result(nil)
            return true
        default:
            return false
        }
    }
}