//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class LoadableNativeObject: NativeHandler {
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
        case "getLoadStatus":
            result(loadable.loadStatus.rawValue)
            return true
        case "getLoadError":
            result(loadable.loadError?.toJSON())
            return true
        case "cancelLoad":
            loadable.cancelLoad()
            result(nil)
            return true
        case "loadAsync":
            loadable.load { [weak self] (error) in
                guard let self = self else {
                    return
                }
                self.onLoadCallback(error: error, result: result)
            }
            return true
        case "retryLoadAsync":
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
            messageSink?.send(method: "loadStatusChanged", arguments: loadStatus.rawValue)
        }
        result(nil)
    }

}