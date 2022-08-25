//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

protocol NativeHandler {
    var messageSink: NativeMessageSink? { get set }

    func dispose() -> Void

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool
}


class BaseNativeHandler<T>: NSObject, NativeHandler {

    let nativeHandler: T

    init(nativeHandler: T) {
        self.nativeHandler = nativeHandler
    }

    deinit {
        dispose()
    }

    var messageSink: NativeMessageSink?

    func dispose() {
        messageSink = nil
    }

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        false
    }

    func sendMessage(method: String, arguments: Any?) {
        messageSink?.send(method: method, arguments: arguments)
    }
}

protocol NativeObject {
    var objectId: String { get }

    var messageSink: NativeMessageSink { get }

    func dispose()

    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult)
}

public class NativeObjectMessageSink: NativeMessageSink {
    private let objectId: String

    private let messageSink: NativeMessageSink

    init(objectId: String, messageSink: NativeMessageSink) {
        self.objectId = objectId
        self.messageSink = messageSink
    }

    public func send(method: String, arguments: Any?) {
        messageSink.send(method: "messageNativeObject", arguments: [
            "objectId": objectId,
            "method": method,
            "arguments": arguments
        ])
    }
}


class BaseNativeObject<T>: NativeMessageSink, NativeObject {
    private var nativeObjectMessageSink: NativeObjectMessageSink

    private var isDisposed: Bool = false
    private let nativeHandlers: [NativeHandler]

    let objectId: String

    let nativeObject: T

    var messageSink: NativeMessageSink

    init(objectId: String, nativeObject: T, nativeHandlers: [NativeHandler], messageSink: NativeMessageSink) {
        self.objectId = objectId
        self.nativeObject = nativeObject
        self.nativeHandlers = nativeHandlers
        self.messageSink = messageSink
        nativeObjectMessageSink = NativeObjectMessageSink(objectId: objectId, messageSink: messageSink)

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
        if (isDisposed) {
            return
        }
        nativeObjectMessageSink.send(method: "messageNativeObject", arguments: arguments)
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