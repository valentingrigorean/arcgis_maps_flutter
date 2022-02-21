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
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let spactialReference = AGSSpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
            guard let geometry = AGSGeometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>) else {
                result(nil)
                return
            }
            guard let projectedGeometry = AGSGeometryEngine.projectGeometry(geometry, to: spactialReference) else {
                result(nil)
                return
            }
            result(projectedGeometry.toJSONFlutter())
            break
        case "distanceGeodetic":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let point1 = AGSPoint(data: data["point1"] as! Dictionary<String, Any>)
            let point2 = AGSPoint(data: data["point2"] as! Dictionary<String, Any>)
            let distanceUnitId = AGSLinearUnitID.fromFlutter(data["distanceUnitId"] as! Int)
            let azimuthUnitId = AGSAngularUnitID.fromFlutter(data["azimuthUnitId"] as! Int)
            let curveType = AGSGeodeticCurveType.init(rawValue: data["curveType"] as! Int)!
            let geodeticDistanceResult = AGSGeometryEngine.geodeticDistanceBetweenPoint1(point1, point2: point2,
                    distanceUnit: AGSLinearUnit(unitID: distanceUnitId)!,
                    azimuthUnit: AGSAngularUnit(unitID: azimuthUnitId)!,
                    curveType: curveType)
            result(geodeticDistanceResult?.toJSONFlutter())
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}