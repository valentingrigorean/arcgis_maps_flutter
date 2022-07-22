//
// Created by Valentin Grigorean on 17.01.2022.
//

import Foundation
import ArcGIS

class CoordinateFormatterController {

    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/coordinate_formatter", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch call.method {
        case "latitudeLongitudeString":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let from = AGSGeometry.fromFlutter(data: data["from"] as! Dictionary<String, Any>) as! AGSPoint
            let format = data["format"] as! Int
            let decimalPlaces = data["decimalPlaces"] as! Int
            result(AGSCoordinateFormatter.latitudeLongitudeString(from: from, format: AGSLatitudeLongitudeFormat(rawValue: format)!, decimalPlaces: decimalPlaces))
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}