//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class LoadableNativeHandler: BaseNativeHandler<Loadable> {
    private var cancelTask : Task<Void,Never>?
    private var loadTask : Task<Void,Never>?
    private var retryTask : Task<Void,Never>?
    var loadStatus: LoadStatus

    init(loadable: Loadable) {
        loadStatus = loadable.loadStatus
        super.init(nativeHandler: loadable)
    }
    
    deinit{
        cancelTask?.cancel()
        loadTask?.cancel()
        retryTask?.cancel()
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "loadable#getLoadStatus":
            result(nativeHandler.loadStatus.toFlutterValue())
            return true
        case "loadable#getLoadError":
            result(nativeHandler.loadError?.toFlutterJson())
            return true
        case "loadable#cancelLoad":
            cancelTask = Task{
               await  nativeHandler.cancelLoad()
                result(nil)
            }
            return true
        case "loadable#loadAsync":
            loadTask = Task{
                do {
                    try await nativeHandler.load()
                    self.onLoadCallback(error: nil, result: result)
                }catch{
                    self.onLoadCallback(error: error, result: result)
                }
            }
            return true
        case "loadable#retryLoadAsync":
            retryTask = Task {
                do {
                    try await nativeHandler.retryLoad()
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
