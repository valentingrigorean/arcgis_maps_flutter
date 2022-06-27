//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

class OfflineMapTaskController {
    private let channel: FlutterMethodChannel
    private let messenger: FlutterBinaryMessenger
    private var offlineMapTasks: [Int: AGSOfflineMapTask] = [:]
    private var offlineMapCredentials: [Int: AGSCredential] = [:]
    private var jobs: [Int: GenerateOfflineMapJobController] = [:]

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/offline_map_task", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createOfflineMapTask":
            createOfflineMapTask(data: call.arguments as! [String: Any])
            result(nil)
            break
        case "destroyOfflineMapTask":
            offlineMapTasks.removeValue(forKey: call.arguments as! Int)
            offlineMapCredentials.removeValue(forKey: call.arguments as! Int)
            result(nil)
            break
        case "defaultGenerateOfflineMapParameters":
            defaultGenerateOfflineMapParameters(data: call.arguments as! [String: Any], result: result)
            break
        case "destroyGenerateOfflineMapJob":
            jobs.removeValue(forKey: call.arguments as! Int)
            result(nil)
            break
        case "generateOfflineMap":
            generateOfflineMap(data: call.arguments as! [String: Any], result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func generateOfflineMap(data: [String: Any], result: @escaping FlutterResult) {
        let id = data["id"] as! Int
        let jobId = data["jobId"] as! Int
        let parameters = AGSGenerateOfflineMapParameters(data: data["parameters"] as! [String: Any])
        let downloadDirectory = data["downloadDirectory"] as! String

        let offlineMapTask = offlineMapTasks[id]!
        let offlineMapJob = offlineMapTask.generateOfflineMapJob(with: parameters, downloadDirectory: URL(string: downloadDirectory)!)
        let jobController = GenerateOfflineMapJobController(messenger: messenger, id: jobId, offlineMapJob: offlineMapJob)
        jobs[jobId] = jobController
        result(nil)
    }

    private func defaultGenerateOfflineMapParameters(data: [String: Any], result: @escaping FlutterResult) {
        let id = data["id"] as! Int
        let offlineMapTask = offlineMapTasks[id]!
        let areaOfInterest = AGSGeometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as? Double
        let maxScale = data["maxScale"] as? Double

        if minScale == nil {
            offlineMapTask.defaultGenerateOfflineMapParameters(withAreaOfInterest: areaOfInterest, completion: { (parameters, error) in
                if let error = error {
                    result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(parameters?.toJSONFlutter())
                }
            })
        } else {
            offlineMapTask.defaultGenerateOfflineMapParameters(withAreaOfInterest: areaOfInterest, minScale: minScale!, maxScale: maxScale!, completion: { (parameters, error) in
                if let error = error {
                    result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(parameters?.toJSONFlutter())
                }
            })
        }
    }

    private func createOfflineMapTask(data: [String: Any]) {
        var offlineMapTask: AGSOfflineMapTask
        if let map = data["map"] as? Dictionary<String, Any> {
            offlineMapTask = AGSOfflineMapTask(onlineMap: AGSMap(data: map))
        } else if let portalItem = data["portalItem"] as? Dictionary<String, Any> {
            offlineMapTask = AGSOfflineMapTask(portalItem: AGSPortalItem(data: portalItem))
        } else {
            fatalError("Invalid offline map task")
        }

        let id = data["id"] as! Int
        offlineMapTasks[id] = offlineMapTask
        if let credentials = data["credentials"] as? Dictionary<String, Any> {
            offlineMapCredentials[id] = AGSCredential(data: credentials)
        }
    }
}