//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class RemoteResourceNativeHandler: NativeHandler {
    private let remoteResource: AGSRemoteResource

    init(remoteResource: AGSRemoteResource) {
        self.remoteResource = remoteResource
    }

    var messageSink: NativeMessageSink?

    func dispose() {
        messageSink = nil
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "remoteResource#getUrl":
            result(remoteResource.url?.absoluteString)
            return true
        case "remoteResource#getCredential":
            result(remoteResource.credential?.toJSONFlutter())
            return true
        case "remoteResource#setCredential":
            if let credential = arguments as? Dictionary<String, Any> {
                remoteResource.credential = AGSCredential(data: credential)
            }
            result(nil)
            return true
        default:
            return false
        }
    }

}