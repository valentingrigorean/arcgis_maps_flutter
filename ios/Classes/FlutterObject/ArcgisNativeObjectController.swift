//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

protocol NativeHandler {
    var messageSink: NativeMessageSink? { get set }

    func dispose() -> Void

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool
}

class ArcgisNativeObjectController: NativeMessageSink {

    private var isDisposed: Bool = false
    private let nativeHandlers: [NativeHandler]

    let messageSink: NativeObjectControllerMessageSink
    let objectId: String

    init(objectId: String, nativeHandlers: [NativeHandler], messageSink: NativeObjectControllerMessageSink) {
        self.objectId = objectId
        self.nativeHandlers = nativeHandlers
        self.messageSink = messageSink

        for var handler in nativeHandlers {
            handler.messageSink = self
        }
    }

    deinit {
        dispose()
    }

    var storage: NativeObjectStorage {
        get {
            NativeObjectStorage.shared
        }
    }

    func dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        for handler in nativeHandlers {
            handler.dispose()
        }
    }

    func send(method: String, arguments: Any?) {
        messageSink.send(method: "messageNativeObject", arguments: [
            "objectId": objectId,
            "method": method,
            "arguments": arguments
        ])
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        for handler in nativeHandlers {
            if handler.onMethodCall(method: method, arguments: arguments, result: result) {
                return
            }
        }
        result(FlutterMethodNotImplemented)
    }
}