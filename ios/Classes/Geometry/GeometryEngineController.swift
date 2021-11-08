//
// Created by Valentin Grigorean on 08.11.2021.
//

import Foundation
import ArcGIS

class GeometryEngineController {
    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/geometry_engine", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {

        switch (call.method) {
        case "project":
            if let data = call.arguments as? Dictionary<String, Any> {
                let spactialReference = AGSSpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
                guard let geometry = AGSGeometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>) else {
                    result(nil)
                    return
                }
                guard let projectedGeometry = AGSGeometryEngine.projectGeometry(geometry, to: spactialReference) else {
                    result(nil)
                    return
                }
                result(projectedGeometry.toFlutterJson())
            }
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}