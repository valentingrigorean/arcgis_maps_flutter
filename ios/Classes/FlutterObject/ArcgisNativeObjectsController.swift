//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

protocol NativeMessageSink {
    func send(method: String, arguments: Any?) -> Void
}

protocol ArcgisNativeObjectFactory {
    func createNativeObject(objectId: String, type: String, arguments: Any?, messageSink: NativeMessageSink) -> NativeObject
}

class ArcgisNativeObjectsController: NativeMessageSink {

    private let channel: FlutterMethodChannel

    private let factory: ArcgisNativeObjectFactory

    init(messenger: FlutterBinaryMessenger, factory: ArcgisNativeObjectFactory) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/native_objects", binaryMessenger: messenger)
        self.factory = factory
        setMethodCallHandlers()
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    func send(method: String, arguments: Any?) {
        channel.invokeMethod(method, arguments: arguments)
    }

    private func createNativeObject(objectId: String, type: String, arguments: Any?) -> NativeObject {
        let nativeObject = factory.createNativeObject(objectId: objectId, type: type, arguments: arguments, messageSink: self)
        NativeObjectStorage.shared.addNativeObject(object: nativeObject)
        return nativeObject
    }

    private func setMethodCallHandlers() {
        channel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self else {
                return
            }
            self.methodCallHandler(call: call, result: result)
        })
    }

    private func methodCallHandler(call: FlutterMethodCall, result: @escaping FlutterResult){
        switch (call.method) {
        case "createNativeObject":
            let args = call.arguments as! [String: Any]
            let objectId = args["objectId"] as! String
            let type = args["type"] as! String
            let arguments = args["arguments"]
            let nativeObject = createNativeObject(objectId: objectId, type: type, arguments: arguments)
            NativeObjectStorage.shared.addNativeObject(object: nativeObject)
            result(nil)
            break;
        case "destroyNativeObject":
            let objectId = call.arguments as! String
            NativeObjectStorage.shared.removeNativeObject(objectId: objectId)
            result(nil)
            break;
        case "sendMessage":
            let args = call.arguments as! [String: Any]
            let objectId = args["objectId"] as! String
            let method = args["method"] as! String
            let arguments = args["arguments"]
            let nativeObject = NativeObjectStorage.shared.getNativeObject(objectId: objectId)
            if let nativeObject = nativeObject {
                nativeObject.onMethodCall(method: method, arguments: arguments, result: result)
            } else {
                result(FlutterError(code: "object_not_found", message: "Native object not found", details: nil))
            }
            break;
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
