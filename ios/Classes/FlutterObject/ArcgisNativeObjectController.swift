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

    private let objectId: String
    private let nativeHandlers: [NativeHandler]
    private let messageSink: NativeMessageSink
    var isDisposed: Bool = false

    init(objectId: String, nativeHandlers: [NativeHandler], messageSink: NativeMessageSink) {
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

    var parent: ArcgisNativeObjectsController?

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
        messageSink.send(method: method, arguments: [])
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