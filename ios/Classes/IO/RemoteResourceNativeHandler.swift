//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class RemoteResourceNativeHandler: BaseNativeHandler<AGSRemoteResource> {

    init(remoteResource: AGSRemoteResource) {
        super.init(nativeHandler: remoteResource)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "remoteResource#getUrl":
            result(nativeHandler.url?.absoluteString)
            return true
        case "remoteResource#getCredential":
            result(nativeHandler.credential?.toJSONFlutter())
            return true
        case "remoteResource#setCredential":
            if let credential = arguments as? Dictionary<String, Any> {
                nativeHandler.credential = AGSCredential(data: credential)
            }
            result(nil)
            return true
        default:
            return false
        }
    }

}