//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ExportTileCacheTaskNativeObject: BaseNativeObject<AGSExportTileCacheTask> {

    init(objectId: String, task: AGSExportTileCacheTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
            RemoteResourceNativeHandler(remoteResource: task),
            ApiKeyResourceNativeHandler(apiKeyResource: task)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "exportTileCacheTask#createDefaultExportTileCacheParameters":
            createDefaultExportTileCacheParameters(arguments: arguments, result: result)
            break
        case "exportTileCacheTask#estimateTileCacheSizeJob":
            estimateTileCacheSizeJob(arguments: arguments, result: result)
            break
        case "exportTileCacheTask#exportTileCacheJob":
            exportTileCacheJob(arguments: arguments, result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }

    private func createDefaultExportTileCacheParameters(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let areaOfInterest = AGSGeometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as! Double
        let maxScale = data["maxScale"] as! Double
        nativeObject.exportTileCacheParameters(withAreaOfInterest: areaOfInterest, minScale: minScale, maxScale: maxScale) { (parameters, error) in
            if let params = parameters {
                result(params.toJSONFlutter())
            } else {
                result(error?.toJSON())
            }
        }
    }

    private func estimateTileCacheSizeJob(arguments: Any?, result: @escaping FlutterResult) {
        let params = AGSExportTileCacheParameters(data: arguments as! [String: Any])
        let job = nativeObject.estimateTileCacheSizeJob(with: params)
        let jobId = NSUUID().uuidString

        let jobNativeObject = EstimateTileCacheSizeJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }

    private func exportTileCacheJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let params = AGSExportTileCacheParameters(data: data["parameters"] as! [String: Any])
        let fileNameWithPath = data["fileNameWithPath"] as! String
        let job = nativeObject.exportTileCacheJob(with: params, downloadFileURL: URL(string: fileNameWithPath)!)
        let jobId = NSUUID().uuidString

        let jobNativeObject = ExportTileCacheJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}
