//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

class OfflineMapSyncTaskNativeObject: NativeObject {
    private let offlineMapPath: String
    private var pendingMessages = [MethodCall]()
    private var task: OfflineMapSyncTaskNativeObjectWrapper?
    private var isDisposed = false

    init(objectId: String, offlineMapPath: String, messageSink: NativeMessageSink) {
        self.objectId = objectId
        self.messageSink = NativeObjectMessageSink(objectId: objectId, messageSink: messageSink)
        self.offlineMapPath = offlineMapPath
        loadOfflineMap()
    }

    let objectId: String

    let messageSink: NativeMessageSink

    func dispose() {
        isDisposed = true
        task?.dispose()
        task = nil
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        if let task = task {
            task.onMethodCall(method: method, arguments: arguments, result: result)
        } else {
            pendingMessages.append(MethodCall(method: method, arguments: arguments, result: result))
        }
    }

    private func loadOfflineMap() {
        let mobilePackages = AGSMobileMapPackage(fileURL: URL(string: offlineMapPath)!)
        mobilePackages.load { error in
            if self.isDisposed {
                return
            }
            if let error = error {
                self.messageSink.send(method: "offlineMapSyncTask#loadError", arguments: error.toJSON())
                return
            }

            if mobilePackages.maps.isEmpty {
                self.messageSink.send(method: "offlineMapSyncTask#loadError", arguments: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No maps in the package"]).toJSON())
                return
            }

            let map = mobilePackages.maps[0]
            let task = AGSOfflineMapSyncTask(map: map)
            self.task = OfflineMapSyncTaskNativeObjectWrapper(objectId: self.objectId, task: task, messageSink: self.messageSink)
            self.pendingMessages.forEach { methodCall in
                self.task?.onMethodCall(method: methodCall.method, arguments: methodCall.arguments, result: methodCall.result)
            }
            self.pendingMessages.removeAll()
        }
    }

}

private struct MethodCall {
    let method: String
    let arguments: Any?
    let result: FlutterResult
}

fileprivate class OfflineMapSyncTaskNativeObjectWrapper: BaseNativeObject<OfflineMapSyncTask> {
    init(objectId: String, task: OfflineMapSyncTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch method {
        case "offlineMapSyncTask#getUpdateCapabilities":
            if let updateCapabilities = nativeObject.updateCapabilities {
                result(updateCapabilities.toJSONFlutter())
            } else {
                result(nil)
            }
            break
        case "offlineMapSyncTask#checkForUpdates":
            nativeObject.checkForUpdates { info, error in
                if let error = error {
                    result(error.toJSON())
                } else {
                    result(info!.toJSONFlutter())
                }
            }
            break
        case "offlineMapSyncTask#defaultOfflineMapSyncParameters":
            nativeObject.defaultOfflineMapSyncParameters { parameters, error in
                if let error = error {
                    result(error.toJSON())
                } else {
                    result(parameters!.toJSONFlutter())
                }
            }
            break
        case "offlineMapSyncTask#offlineMapSyncJob":
            createJob(data: arguments as! Dictionary<String, Any>, result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }

    private func createJob(data: [String: Any], result: @escaping FlutterResult) {
        let parameters = AGSOfflineMapSyncParameters(data: data)
        let job = nativeObject.offlineMapSyncJob(with: parameters)
        let jobId = NSUUID().uuidString
        let jobNativeObject = AGSOfflineMapSyncJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }

}
