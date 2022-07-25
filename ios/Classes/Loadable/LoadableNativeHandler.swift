//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class LoadableNativeHandler: NativeHandler {
    let loadable: AGSLoadable
    var loadStatus: AGSLoadStatus

    init(loadable: AGSLoadable) {
        self.loadable = loadable
        loadStatus = loadable.loadStatus
    }

    var messageSink: NativeMessageSink?

    func dispose() {
        messageSink = nil
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "loadable#getLoadStatus":
            result(loadable.loadStatus.rawValue)
            return true
        case "loadable#getLoadError":
            result(loadable.loadError?.toJSON())
            return true
        case "loadable#cancelLoad":
            loadable.cancelLoad()
            result(nil)
            return true
        case "loadable#loadAsync":
            loadable.load { [weak self] (error) in
                guard let self = self else {
                    return
                }
                self.onLoadCallback(error: error, result: result)
            }
            return true
        case "loadable#retryLoadAsync":
            loadable.retryLoad { [weak self] (error) in
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
        let newStatus = loadable.loadStatus
        if newStatus != loadStatus {
            loadStatus = newStatus
            messageSink?.send(method: "loadable#loadStatusChanged", arguments: loadStatus.rawValue)
        }
        result(nil)
    }

}