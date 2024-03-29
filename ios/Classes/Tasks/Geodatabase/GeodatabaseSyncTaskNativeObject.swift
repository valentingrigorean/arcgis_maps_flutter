//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

class GeodatabaseSyncTaskNativeObject: BaseNativeObject<AGSGeodatabaseSyncTask> {
    init(objectId: String, task: AGSGeodatabaseSyncTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
            RemoteResourceNativeHandler(remoteResource: task),
            ApiKeyResourceNativeHandler(apiKeyResource: task)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "geodatabaseSyncTask#defaultGenerateGeodatabaseParameters":
            defaultGenerateGeodatabaseParameters(arguments: arguments, result: result)
            break
        case "geodatabaseSyncTask#importDelta":
            importDelta(arguments: arguments, result: result)
            break
        case "geodatabaseSyncTask#generateJob":
            generateJob(arguments: arguments, result: result)
            break
        case "geodatabaseSyncTask#defaultSyncGeodatabaseParameters":
            defaultSyncGeodatabaseParameters(arguments: arguments, result: result)
            break
        case "geodatabaseSyncTask#syncJob":
            syncJob(arguments: arguments, result: result)
            break
        case "geodatabaseSyncTask#syncJobWithSyncDirection":
            syncJobWithSyncDirection(arguments: arguments, result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }


    private func defaultGenerateGeodatabaseParameters(arguments: Any?, result: @escaping FlutterResult) {
        let areaOfInterest = AGSGeometry.fromFlutter(data: arguments as! [String: Any])!
        nativeObject.defaultGenerateGeodatabaseParameters(withExtent: areaOfInterest) { parameters, error in
            if let params = parameters {
                result(params.toJSONFlutter())
            } else {
                result(error?.toJSON())
            }
        }
    }

    private func importDelta(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let deltaFilePath = data["deltaFilePath"] as! String
        let geodatabaseId = data["geodatabase"] as! String
        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
        nativeObject.importDelta(with: geodatabase.nativeObject, inputPath: deltaFilePath) { layerResults, error  in
            if let layerRes = layerResults {
                result(layerRes.map({$0.toJSONFlutter()}))
            } else {
                result(nil)
            }
        }
    }

    private func generateJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let parameters = AGSGenerateGeodatabaseParameters(data: data["parameters"] as! [String: Any])
        let fileNameWithPath = data["fileNameWithPath"] as! String
        let job = nativeObject.generateJob(with: parameters, downloadFileURL: URL(string: fileNameWithPath)!)
        let jobId = NSUUID().uuidString
        let jobNativeObject = GenerateGeodatabaseJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }

    private func defaultSyncGeodatabaseParameters(arguments: Any?, result: @escaping FlutterResult) {
        let geodatabaseId = arguments as! String

        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject;

        nativeObject.defaultSyncGeodatabaseParameters(with: geodatabase.nativeObject) { parameters, error in
            if let params = parameters {
                result(params.toJSONFlutter())
            } else {
                result(error?.toJSON())
            }
        }
    }

    private func syncJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let parameters = AGSSyncGeodatabaseParameters(data: data["parameters"] as! [String: Any])
        let geodatabaseId = data["geodatabase"] as! String
        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
        let job = nativeObject.syncJob(with: parameters, geodatabase: geodatabase.nativeObject)
        createSyncJob(job: job, result: result)
    }

    private func syncJobWithSyncDirection(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let syncDirection = AGSSyncDirection(rawValue: data["syncDirection"] as! Int)!
        let rollbackOnFailure = data["rollbackOnFailure"] as! Bool
        let geodatabaseId = data["geodatabase"] as! String
        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
        let job = nativeObject.syncJob(with: syncDirection, rollbackOnFailure: rollbackOnFailure, geodatabase: geodatabase.nativeObject)
        createSyncJob(job: job, result: result)
    }

    private func createSyncJob(job: AGSSyncGeodatabaseJob, result: @escaping FlutterResult) {
        let jobId = NSUUID().uuidString
        let jobNativeObject = SyncGeodatabaseJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}
