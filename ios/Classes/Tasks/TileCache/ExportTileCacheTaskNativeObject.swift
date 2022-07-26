//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ExportTileCacheTaskNativeObject: ArcgisNativeObjectController {

    let exportTileCacheTask: AGSExportTileCacheTask

    init(objectId: String, url: String, messageSink: NativeObjectControllerMessageSink) {
        exportTileCacheTask = AGSExportTileCacheTask(url: URL(string: url)!)
        super.init(objectId: objectId, nativeHandlers: [
            RemoteResourceNativeHandler(remoteResource: exportTileCacheTask),
            ApiKeyResourceNativeHandler(apiKeyResource: exportTileCacheTask)
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
        exportTileCacheTask.exportTileCacheParameters(withAreaOfInterest: areaOfInterest, minScale: minScale, maxScale: maxScale) { (parameters, error) in
            if let params = parameters {
                result(params.toJSONFlutter())
            } else {
                result(error?.toJSON())
            }
        }
    }

    private func estimateTileCacheSizeJob(arguments: Any?, result: @escaping FlutterResult) {
        let params = AGSExportTileCacheParameters(data: arguments as! [String: Any])
        let job = exportTileCacheTask.estimateTileCacheSizeJob(with: params)
        let jobId = NSUUID().uuidString

        let jobNativeObject = EstimateTileCacheSizeJobNativeObject(job: job, objectId: jobId, messageSink: messageSink)
        parent?.addNativeObject(objectId: jobId, nativeObject: jobNativeObject)
        result(jobId)
    }

    private func exportTileCacheJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let params = AGSExportTileCacheParameters(data: data["parameters"] as! [String: Any])
        let fileNameWithPath = data["fileNameWithPath"] as! String
        let job = exportTileCacheTask.exportTileCacheJob(with: params, downloadFileURL: URL(string: fileNameWithPath)!)
        let jobId = NSUUID().uuidString

        let jobNativeObject = ExportTileCacheJobNativeObject(job: job, objectId: jobId, messageSink: messageSink)
        parent?.addNativeObject(objectId: jobId, nativeObject: jobNativeObject)
        result(jobId)
    }
}