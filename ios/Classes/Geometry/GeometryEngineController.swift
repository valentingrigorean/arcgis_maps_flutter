//
// Created by Valentin Grigorean on 08.11.2021.
//

import Foundation
import ArcGIS

class GeometryEngineController {
    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/geometry_engine", binaryMessenger: messenger)
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
        case "bufferGeometry":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = AGSGeometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let distance = data["distance"] as! Double
            let polygon = AGSGeometryEngine.bufferGeometry(geometry, byDistance: distance)
            result(polygon?.toJSONFlutter())
            break
        case "geodeticBufferGeometry":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = AGSGeometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let distance = data["distance"] as! Double
            let distanceUnitId = AGSLinearUnitID.fromFlutter(data["distanceUnit"] as! Int)
            let maxDeviation = data["maxDeviation"] as! Double
            let curveType = AGSGeodeticCurveType.init(rawValue: data["curveType"] as! Int)!
            let polygon = AGSGeometryEngine.geodeticBufferGeometry(geometry, distance: distance,
                    distanceUnit: AGSLinearUnit(unitID: distanceUnitId)!,
                    maxDeviation: maxDeviation,
                    curveType: curveType)
            result(polygon?.toJSONFlutter())
            break
        case "intersection":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let firstGeometry = AGSGeometry.fromFlutter(data: data["firstGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = AGSGeometry.fromFlutter(data: data["secondGeometry"] as! Dictionary<String, Any>)!
            let geometry = AGSGeometryEngine.intersection(ofGeometry1: firstGeometry, geometry2: secondGeometry)
            result(geometry?.toJSONFlutter())
            break
        case "intersections":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result([])
                return
            }
            let firstGeometry = AGSGeometry.fromFlutter(data: data["firstGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = AGSGeometry.fromFlutter(data: data["secondGeometry"] as! Dictionary<String, Any>)!
            guard let geometryList = AGSGeometryEngine.intersections(ofGeometry1: firstGeometry, geometry2: secondGeometry) else {
                result([])
                return
            }
            var geometryResults: [Any] = []
            geometryList.forEach { any in
                if let geometry = any as? AGSGeometry {
                    if let json = geometry.toJSONFlutter() {
                        geometryResults.append(json)
                    }
                }
            }
            result(geometryResults)
            break
        case "contains":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(false)
                return
            }
            let firstGeometry = AGSGeometry.fromFlutter(data: data["containerGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = AGSGeometry.fromFlutter(data: data["withinGeometry"] as! Dictionary<String, Any>)!
            result(AGSGeometryEngine.geometry(firstGeometry, contains: secondGeometry))
            break
        case "geodesicSector":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let params = AGSGeodesicSectorParameters(data: data)
            let geometry = AGSGeometryEngine.geodesicSector(with: params)
            result(geometry?.toJSONFlutter())
            break
        case "geodeticMove":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let points = (data["points"] as! [Dictionary<String, Any>]).map {
                AGSPoint(data: $0)
            }
            let distance = data["distance"] as! Double
            let distanceUnitId = AGSLinearUnitID.fromFlutter(data["distanceUnit"] as! Int)
            let azimuth = data["azimuth"] as! Double
            let azimuthUnitId = AGSAngularUnitID.fromFlutter(data["azimuthUnit"] as! Int)
            let curveType = AGSGeodeticCurveType.init(rawValue: data["curveType"] as! Int)!
            let results = AGSGeometryEngine.geodeticMove(points,
                    distance: distance,
                    distanceUnit: AGSLinearUnit(unitID: distanceUnitId)!,
                    azimuth: azimuth,
                    azimuthUnit: AGSAngularUnit(unitID: azimuthUnitId)!,
                    curveType: curveType
            )
            result(results?.map {
                $0.toJSONFlutter()
            })
            break
        case "simplify":
            guard let geometryData = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            guard let originGeomtry = AGSGeometry.fromFlutter(data: geometryData) else {
                result(nil)
                return
            }
            let simplifiedGeomtry = AGSGeometryEngine.simplifyGeometry(originGeomtry)
            result(simplifiedGeomtry?.toJSONFlutter())
            break
        case "isSimple":
            guard let geometryData = call.arguments as? Dictionary<String, Any> else {
                result(true)
                return
            }
            guard let originGeomtry = AGSGeometry.fromFlutter(data: geometryData) else {
                result(true)
                return
            }
            result(AGSGeometryEngine.geometryIsSimple(originGeomtry))
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
