//
// Created by Valentin Grigorean on 17.01.2022.
//

import Foundation
import ArcGIS

class CoordinateFormatterController {

    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = UIFlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/coordinate_formatter", binaryMessenger: messenger)
        channel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self else {
                return
            }
            self.handle(call: call, result: result)
        })
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch call.method {
        case "latitudeLongitudeString":
            let data = call.arguments as! [String: Any]
            let from = Geometry.fromFlutter(data: data["from"] as! [String: Any]) as! Point
            let format = data["format"] as! Int
            let decimalPlaces = data["decimalPlaces"] as! Int
            result(CoordinateFormatter.latitudeLongitudeString(from: from, format: CoordinateFormatter.LatitudeLongitudeFormat(format), decimalPlaces: decimalPlaces))
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
