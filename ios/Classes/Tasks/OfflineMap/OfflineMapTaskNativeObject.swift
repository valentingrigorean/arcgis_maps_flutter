//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

class OfflineMapTaskNativeObject: BaseNativeObject<AGSOfflineMapTask> {

    init(objectId: String, task: AGSOfflineMapTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "offlineMapTask#defaultGenerateOfflineMapParameters":
            defaultGenerateOfflineMapParameters(data: arguments as! [String: Any], result: result)
            break
        case "offlineMapTask#generateOfflineMap":
            generateOfflineMap(data: arguments as! [String: Any], result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
            break
        }
    }

    private func defaultGenerateOfflineMapParameters(data: [String: Any], result: @escaping FlutterResult) {
        let areaOfInterest = AGSGeometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as? Double
        let maxScale = data["maxScale"] as? Double

        if minScale == nil {
            nativeObject.defaultGenerateOfflineMapParameters(withAreaOfInterest: areaOfInterest, completion: { (parameters, error) in
                if let error = error {
                    result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(parameters?.toJSONFlutter())
                }
            })
        } else {
            nativeObject.defaultGenerateOfflineMapParameters(withAreaOfInterest: areaOfInterest, minScale: minScale!, maxScale: maxScale!, completion: { (parameters, error) in
                if let error = error {
                    result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(parameters?.toJSONFlutter())
                }
            })
        }
    }

    private func generateOfflineMap(data: [String: Any], result: @escaping FlutterResult) {
        let parameters = AGSGenerateOfflineMapParameters(data: data["parameters"] as! [String: Any])
        let downloadDirectory = data["downloadDirectory"] as! String
        let offlineMapJob = nativeObject.generateOfflineMapJob(with: parameters, downloadDirectory: URL(string: downloadDirectory)!)
        let jobId = NSUUID().uuidString
        let jobNativeObject = GenerateOfflineMapJobNativeObject(objectId: jobId, job: offlineMapJob, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}
