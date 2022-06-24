//
// Created by Valentin Grigorean on 24.06.2022.
//

import Foundation
import ArcGIS

class GenerateOfflineMapJobController {
    private let channel: FlutterMethodChannel
    private let offlineMapJob: AGSGenerateOfflineMapJob

    init(messenger: FlutterBinaryMessenger, id: Int, offlineMapJob: AGSGenerateOfflineMapJob) {
        self.offlineMapJob = offlineMapJob
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/offline_map_task/job_\(id)", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)

        offlineMapJob.progress.
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startJob":

            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}