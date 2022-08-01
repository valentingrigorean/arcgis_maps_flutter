//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class JobNativeHandler: BaseNativeHandler<AGSJob> {

    private var status: AGSJobStatus

    private var messageCount: Int
    //TODO(vali): remove if manage to use KVO.I tried but didn't work....
    private var messageTimer: Timer?

    init(job: AGSJob) {
        status = job.status
        messageCount = job.messages.count
        super.init(nativeHandler: job)
        job.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.old, .new], context: nil)
    }

    deinit {
        nativeHandler.progress.removeObserver(self, forKeyPath: "fractionCompleted")
    }

    override func dispose() {
        stopMessageTimer()
        super.dispose()
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "job#getError":
            result(nativeHandler.error?.toJSON())
            return true
        case "job#getJobType":
            result(nativeHandler.jobType.rawValue)
            return true
        case "job#getMessages":
            result(nativeHandler.messages.map({ $0.toJSONFlutter() }))
            return true
        case "job#serverJobId":
            result(nativeHandler.serverJobID)
            return true
        case "job#getStatus":
            result(nativeHandler.status.rawValue)
            return true
        case "job#getProgress":
            result(nativeHandler.progress.fractionCompleted)
            return true
        case "job#start":
            nativeHandler.start(statusHandler: { [weak self]status in
                guard let self = self else {
                    return
                }
                if status == self.status {
                    return
                }
                self.status = status
                self.messageSink?.send(method: "job#onStatusChanged", arguments: status.rawValue)
            }, completion: { [weak self] result, error in
                self?.stopMessageTimer()
                if let error = error {
                    NSLog("\(String(describing: error))")
                }
            })
            startMessageTimer()
            result(true)
            return true
        case "job#cancel":
            nativeHandler.progress.cancel()
            result(true)
            return true
        case "job#pause":
            nativeHandler.progress.pause()
            result(true)
            return true
        default:
            return false
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch (keyPath) {
        case "fractionCompleted":
            let fractionCompleted = nativeHandler.progress.fractionCompleted
            messageSink?.send(method: "job#onProgressChanged", arguments: fractionCompleted)
            break
        default:
            break
        }
    }

    private func startMessageTimer() {
        messageTimer?.invalidate()
        messageTimer = Timer.scheduledTimer(withTimeInterval: 0.250, repeats: true) { [weak self] timer in
            self?.checkMessages()
        }
    }

    private func stopMessageTimer() {
        messageTimer?.invalidate()
        messageTimer = nil
    }


    private func checkMessages() {
        if nativeHandler.messages.count == messageCount {
            return
        }
        for (index, message) in nativeHandler.messages.enumerated() {
            if index >= messageCount {
                messageSink?.send(method: "job#onMessageAdded", arguments: message.toJSONFlutter())
            }
        }
        messageCount = nativeHandler.messages.count
    }
}
