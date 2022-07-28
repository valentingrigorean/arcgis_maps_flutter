//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class LoadableNativeHandler: BaseNativeHandler<AGSLoadable> {
    var loadStatus: AGSLoadStatus

    init(loadable: AGSLoadable) {
        loadStatus = loadable.loadStatus
        super.init(nativeHandler: loadable)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "loadable#getLoadStatus":
            result(nativeHandler.loadStatus.rawValue)
            return true
        case "loadable#getLoadError":
            result(nativeHandler.loadError?.toJSON())
            return true
        case "loadable#cancelLoad":
            nativeHandler.cancelLoad()
            result(nil)
            return true
        case "loadable#loadAsync":
            nativeHandler.load { [weak self] (error) in
                guard let self = self else {
                    return
                }
                self.onLoadCallback(error: error, result: result)
            }
            return true
        case "loadable#retryLoadAsync":
            nativeHandler.retryLoad { [weak self] (error) in
                guard let self = self else {
                    return
                }
                self.onLoadCallback(error: error, result: result)
            }
            return true
        default:
            return false
        }
    }


    private func onLoadCallback(error: Error?, result: @escaping FlutterResult) {
        let newStatus = nativeHandler.loadStatus
        if newStatus != loadStatus {
            loadStatus = newStatus
            sendMessage(method: "loadable#loadStatusChanged", arguments: loadStatus.rawValue)
        }
        result(nil)
    }

}