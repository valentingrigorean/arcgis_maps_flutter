//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

protocol NativeMessageSink {
    func send(method: String, arguments: Any?) -> Void
}

protocol ArcgisNativeObjectFactory {
    func createNativeObject(objectId: Int, type: String, arguments: Any?, messageSink: NativeMessageSink) -> ArcgisNativeObjectController
}

class ArcgisNativeObjectsController: NativeMessageSink {
    private let channel: FlutterMethodChannel
    private let factory: ArcgisNativeObjectFactory
    private var nativeObjects: [Int: ArcgisNativeObjectController] = [:]

    init(messenger: FlutterBinaryMessenger, factory: ArcgisNativeObjectFactory) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/native_objects", binaryMessenger: messenger)
        self.factory = factory
        channel.setMethodCallHandler(handle)
    }

    func send(method: String, arguments: Any?) {
        channel.invokeMethod(method, arguments: arguments)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "createNativeObject":
            let args = call.arguments as! [String: Any]
            let objectId = args["objectId"] as! Int
            let type = args["type"] as! String
            let arguments = args["arguments"]
            let nativeObject = factory.createNativeObject(objectId: objectId, type: type, arguments: arguments, messageSink: self)
            nativeObjects[objectId] = nativeObject
            result(nil)
            break;
        case "destroyNativeObject":
            let objectId = call.arguments as! Int
            let nativeObject = nativeObjects.removeValue(forKey: objectId)
            nativeObject?.dispose()
            result(nil)
            break;
            case "sendMessage":
                let args = call.arguments as! [String: Any]
                let objectId = args["objectId"] as! Int
                let method = args["method"] as! String
                let arguments = args["arguments"]
                let nativeObject = nativeObjects[objectId]
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