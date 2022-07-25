//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ApiKeyResourceNativeHandler: NativeHandler {
    private let apiKeyResource: AGSAPIKeyResource

    init(apiKeyResource: AGSAPIKeyResource) {
        self.apiKeyResource = apiKeyResource
    }

    var messageSink: NativeMessageSink?

    func dispose() {
        messageSink = nil
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "apiKeyResource#getApiKey":
            result(apiKeyResource.apiKey)
            return true
        case "apiKeyResource#setApiKey":
            if let apiKey = arguments as? String {
                apiKeyResource.apiKey = apiKey
            }
            result(nil)
            return true
        default:
            return false
        }
    }
}