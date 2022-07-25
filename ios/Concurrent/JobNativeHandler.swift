//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class JobNativeHandler: NSObject, NativeHandler {

    private var status: AGSJobStatus = .notStarted

    private let job: AGSJob

    init(job: AGSJob) {
        self.job = job
        super.init()
        job.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.old, .new], context: nil)
    }

    deinit {
        dispose()
    }

    var messageSink: NativeMessageSink?

    func dispose() {
        messageSink = nil
        job.progress.removeObserver(self, forKeyPath: "fractionCompleted")
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "job#getError":
            result(job.error?.toJSON())
            return true
        case "job#getJobType":
            result(job.jobType.rawValue)
            return true
        case "job#serverJobId":
            result(job.serverJobID)
            return true
        case "job#getStatus":
            result(job.status.rawValue)
            return true
        case "job#getProgress":
            result(job.progress.fractionCompleted)
            return true
        case "job#start":
            job.start(statusHandler: { [weak self]status in
                guard let self = self else {
                    return
                }
                if status == self.status {
                    return
                }
                self.status = status
                self.messageSink?.send(method: "job#onStatusChanged", arguments: status.rawValue)
            }, completion: { [weak self]result, error in
                NSLog("\(String(describing: error))")
            })
            result(true)
            return true
        case "job#cancel":
            job.progress.cancel()
            result(true)
            return true
        case "job#pause":
            job.progress.pause()
            result(true)
            return true
        default:
            return false
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch (keyPath) {
        case "fractionCompleted":
            let fractionCompleted = job.progress.fractionCompleted
            messageSink?.send(method: "job#onProgressChanged", arguments: fractionCompleted)
            break
        default:
            break
        }
    }
}