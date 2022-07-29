//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

class GeodatabaseSyncTaskNativeObject: BaseNativeObject<AGSGeodatabaseSyncTask> {
    init(objectId: String, task: AGSGeodatabaseSyncTask, messageSink: NativeObjectControllerMessageSink) {
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
        case "geodatabaseSyncTask#generateJob":
            generateJob(arguments: arguments, result: result)
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

    private func generateJob(arguments: Any?, result: @escaping FlutterResult) {
        let data = arguments as! [String: Any]
        let parameters = AGSGenerateGeodatabaseParameters(data: data["parameters"] as! [String: Any])
        let fileNameWithPath = data["fileNameWithPath"] as! String
        let job = nativeObject.generateJob(with: parameters, downloadFileURL: URL(string: fileNameWithPath)!)
        print("JobType: \(job.jobType)")
        let jobId = NSUUID().uuidString
        let jobNativeObject = GenerateGeodatabaseJobNativeObject(objectId: jobId, job: job, messageSink: messageSink)
        storage.addNativeObject(object: jobNativeObject)
        result(jobId)
    }
}