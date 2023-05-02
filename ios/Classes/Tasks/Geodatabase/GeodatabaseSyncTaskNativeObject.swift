//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

class GeodatabaseSyncTaskNativeObject: BaseNativeObject<GeodatabaseSyncTask> {
    init(objectId: String, task: GeodatabaseSyncTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
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
        createTask {
            let areaOfInterest = Geometry.fromFlutter(data: arguments as! [String: Any])!
            do{
                let params = try await self.nativeObject.makeDefaultGenerateGeodatabaseParameters(extent: areaOfInterest)
                result(params.toJSONFlutter())
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func importDelta(arguments: Any?, result: @escaping FlutterResult) {
        createTask {
            let data = arguments as! [String: Any]
            let deltaFilePath = data["deltaFilePath"] as! String
            let geodatabaseId = data["geodatabase"] as! String
            let geodatabase = self.storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
            do{
                let layers = try await GeodatabaseSyncTask.importDelta(from:URL(fileURLWithPath: deltaFilePath), into: geodatabase.nativeObject)
                result(layers.map{ $0.toJSONFlutter() })
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func generateJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let parameters = GenerateGeodatabaseParameters(data: data["parameters"] as! [String: Any])
        let fileNameWithPath = data["fileNameWithPath"] as! String
        let job = nativeObject.makeGenerateGeodatabaseJob(parameters: parameters, downloadFileURL: URL(fileURLWithPath: fileNameWithPath))
        let jobId = NSUUID().uuidString
        let jobNativeObject = GenerateGeodatabaseJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
    
    private func defaultSyncGeodatabaseParameters(arguments: Any?, result: @escaping FlutterResult) {
        createTask {
            let geodatabaseId = arguments as! String
            
            let geodatabase = self.storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject;
            
            do{
                let parameters = try await self.nativeObject.makeDefaultSyncGeodatabaseParameters(geodatabase: geodatabase.nativeObject)
                result(parameters.toJSONFlutter())
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func syncJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let parameters = SyncGeodatabaseParameters(data: data["parameters"] as! [String: Any])
        let geodatabaseId = data["geodatabase"] as! String
        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
        let job = nativeObject.makeSyncGeodatabaseJob(parameters: parameters, geodatabase: geodatabase.nativeObject)
        createSyncJob(job: job, result: result)
    }
    
    private func syncJobWithSyncDirection(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let syncDirection = SyncDirection.fromFlutter(flutterValue: data["syncDirection"] as! Int)
        let rollbackOnFailure = data["rollbackOnFailure"] as! Bool
        let geodatabaseId = data["geodatabase"] as! String
        let geodatabase = storage.getNativeObject(objectId: geodatabaseId) as! GeodatabaseNativeObject
        let job = nativeObject.makeSyncGeodatabaseJob(syncDirection: syncDirection, rollbackOnFailure: rollbackOnFailure, geodatabase: geodatabase.nativeObject)
        createSyncJob(job: job, result: result)
    }
    
    private func createSyncJob(job: SyncGeodatabaseJob, result: @escaping FlutterResult) {
        let jobId = NSUUID().uuidString
        let jobNativeObject = SyncGeodatabaseJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}
