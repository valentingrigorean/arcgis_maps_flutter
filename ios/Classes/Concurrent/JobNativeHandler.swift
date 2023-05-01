//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS


class JobNativeHandler<T: Job & JobProtocol > : BaseNativeHandler<T> {
    
    private var status: Job.Status
    
    init(job: T) {
        status = job.status
        super.init(nativeHandler: job)
        job.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.old, .new], context: nil)
    }
    
    deinit {
        nativeHandler.progress.removeObserver(self, forKeyPath: "fractionCompleted")
    }
    
    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        switch (method) {
        case "job#getError":
            createTask {
                do {
                    let output = try await self.nativeHandler.result.get()
                    result(nil)
                } catch {
                    result(error.toJSONFlutter())
                }
            }
            return true
        case "job#getMessages":
            createTask {
                let messages = await self.getCurrentMessages()
                result(messages.map({ $0.toJSONFlutter() }))
            }
            return true
        case "job#serverJobId":
            result(nativeHandler.serverJobID)
            return true
        case "job#getStatus":
            result(nativeHandler.status.toFlutterValue())
            return true
        case "job#getProgress":
            result(nativeHandler.progress.fractionCompleted)
            return true
        case "job#start":
            nativeHandler.start()
            result(true)
            return true
        case "job#cancel":
            createTask {
                await self.nativeHandler.cancel()
                result(true)
            }
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
    
    func getCurrentMessages() async -> [ArcGIS.JobMessage] {
        var messages: [ArcGIS.JobMessage] = []
        for await message in nativeHandler.messages {
            messages.append(message)
        }
        return messages
    }
}
