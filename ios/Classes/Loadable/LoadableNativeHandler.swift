//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class LoadableNativeHandler: BaseNativeHandler<Loadable> {
    var loadStatus: LoadStatus

    init(loadable: Loadable) {
        loadStatus = loadable.loadStatus
        super.init(nativeHandler: loadable)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "loadable#getLoadStatus":
            result(nativeHandler.loadStatus.toFlutterValue())
            return true
        case "loadable#getLoadError":
            result(nativeHandler.loadError?.toJSONFlutter())
            return true
        case "loadable#cancelLoad":
            createTask {
                await self.nativeHandler.cancelLoad()
                result(nil)
            }
            return true
        case "loadable#loadAsync":
            createTask {
                do {
                    try await self.nativeHandler.load()
                    self.onLoadCallback(error: nil, result: result)
                }catch{
                    self.onLoadCallback(error: error, result: result)
                }
            }
            return true
        case "loadable#retryLoadAsync":
            createTask {
                do {
                    try await self.nativeHandler.retryLoad()
                    self.onLoadCallback(error: nil, result: result)
                }catch{
                    self.onLoadCallback(error: error, result: result)
                }
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
            sendMessage(method: "loadable#loadStatusChanged", arguments: loadStatus.toFlutterValue())
        }
        result(nil)
    }

}
