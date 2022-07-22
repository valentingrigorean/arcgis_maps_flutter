//
// Created by Valentin Grigorean on 24.06.2022.
//

import Foundation
import ArcGIS

class GenerateOfflineMapJobController: NSObject {
    private let channel: FlutterMethodChannel
    private let offlineMapJob: AGSGenerateOfflineMapJob
    var status: AGSJobStatus = .notStarted

    init(messenger: FlutterBinaryMessenger, id: Int, offlineMapJob: AGSGenerateOfflineMapJob) {
        self.offlineMapJob = offlineMapJob
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/offline_map_task/job_\(id)", binaryMessenger: messenger)
        super.init()
        channel.setMethodCallHandler(handle)
        offlineMapJob.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.old, .new], context: nil)
    }

    deinit {
        offlineMapJob.progress.removeObserver(self, forKeyPath: "fractionCompleted")
        channel.setMethodCallHandler(nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        switch (keyPath) {
        case "fractionCompleted":
            let fractionCompleted = offlineMapJob.progress.fractionCompleted
            channel.invokeMethod("onProgressChanged", arguments: fractionCompleted)
            break
        default:
            break
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getJobProgress":
            result(offlineMapJob.progress.fractionCompleted)
            break
        case "getJobStatus":
            result(offlineMapJob.status.rawValue)
            break
        case "startJob":
            offlineMapJob.start(statusHandler: { [weak self]status in
                guard let self = self else {
                    return
                }
                if status == self.status {
                    return
                }
                self.status = status
                self.channel.invokeMethod("onStatusChanged", arguments: status.rawValue)
            }, completion: { [weak self]result, error in
                NSLog("\(String(describing: error))")
            })
            result(true)
            break
        case "cancelJob":
            offlineMapJob.progress.cancel()
            result(true)
            break
        case "pauseJob":
            offlineMapJob.progress.pause()
            result(true)
            break
        case "getError":
            result(offlineMapJob.error?.toJSON())
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}