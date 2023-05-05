//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ApiKeyResourceNativeHandler: BaseNativeHandler<APIKeyResource> {

    init(apiKeyResource: APIKeyResource) {
        super.init(nativeHandler: apiKeyResource)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "apiKeyResource#getApiKey":
            result(nativeHandler.apiKey?.rawValue)
            return true
        case "apiKeyResource#setApiKey":
            if let apiKey = arguments as? String {
                nativeHandler.apiKey = APIKey(apiKey)!
            }
            result(nil)
            return true
        default:
            return false
        }
    }
}
