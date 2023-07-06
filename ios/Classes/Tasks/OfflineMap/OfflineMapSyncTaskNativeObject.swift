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

    deinit {
        isDisposed = true
    }

    let objectId: String

    let messageSink: NativeMessageSink

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        if let task = task {
            task.onMethodCall(method: method, arguments: arguments, result: result)
        } else {
            pendingMessages.append(MethodCall(method: method, arguments: arguments, result: result))
        }
    }

    private func loadOfflineMap() {
        Task {
            let mobilePackages = MobileMapPackage(fileURL: URL(string: offlineMapPath)!)

            do {
                await try mobilePackages.load()
                if mobilePackages.maps.isEmpty {
                    self.messageSink.send(method: "offlineMapSyncTask#loadError", arguments: FlutterError(code: "no_maps", message: "No maps in the package", details: nil))
                    return
                }
                let map = mobilePackages.maps[0]
                let task = OfflineMapSyncTask(map: map)
                self.task = OfflineMapSyncTaskNativeObjectWrapper(objectId: self.objectId, task: task, messageSink: self.messageSink)
                self.pendingMessages.forEach { methodCall in
                    self.task?.onMethodCall(method: methodCall.method, arguments: methodCall.arguments, result: methodCall.result)
                }
                self.pendingMessages.removeAll()
            } catch {
                self.messageSink.send(method: "offlineMapSyncTask#loadError", arguments: error.toJSONFlutter())
            }
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
            createTask {
                do {
                    let updateInfo = try await self.nativeObject.checkForUpdates()
                    result(updateInfo.toJSONFlutter())
                } catch {
                    result(error.toJSONFlutter(withStackTrace: false))
                }
            }
            break
        case "offlineMapSyncTask#defaultOfflineMapSyncParameters":
            createTask {
                do {
                    let params = try await self.nativeObject.makeDefaultOfflineMapSyncParameters()
                    result(params.toJSONFlutter())
                } catch {
                    result(error.toJSONFlutter(withStackTrace: false))
                }
            }
            break
        case "offlineMapSyncTask#offlineMapSyncJob":
            createJob(data: arguments as! [String: Any], result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }

    private func createJob(data: [String: Any], result: @escaping FlutterResult) {
        let parameters = OfflineMapSyncParameters(data: data)
        let job = nativeObject.makeSyncOfflineMapJob(parameters: parameters)
        let jobId = NSUUID().uuidString
        let jobNativeObject = OfflineMapSyncJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}
