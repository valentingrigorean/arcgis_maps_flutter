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
            let spatialReference = SpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
            guard let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>) else {
                result(nil)
                return
            }
            guard let projectedGeometry = GeometryEngine.project(geometry, into: spatialReference) else {
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
            let point1 = Point(data: data["point1"] as! Dictionary<String, Any>)
            let point2 = Point(data: data["point2"] as! Dictionary<String, Any>)
            let distanceUnit = LinearUnit(flutterValue:data["distanceUnitId"] as! Int)
            let azimuthUnit = AngularUnit(flutterValue: data["azimuthUnitId"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            let geodeticDistanceResult = GeometryEngine.geodeticDistance(from: point1, to: point2, distanceUnit: distanceUnit, azimuthUnit: azimuthUnit, curveType: curveType)
            result(geodeticDistanceResult?.toJSONFlutter())
        case "bufferGeometry":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let distance = data["distance"] as! Double
            let polygon = GeometryEngine.buffer(around: geometry, distance: distance)
            result(polygon?.toJSONFlutter())
            break
        case "geodeticBufferGeometry":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let distance = data["distance"] as! Double
            let distanceUnit = LinearUnit(flutterValue:data["distanceUnit"] as! Int)
            let maxDeviation = data["maxDeviation"] as! Double
            let curveType = GeometryEngine.GeodeticCurveType( data["curveType"] as! Int)
            let polygon = GeometryEngine.geodeticBuffer(around: geometry, distance: distance, distanceUnit: distanceUnit, maxDeviation: maxDeviation, curveType: curveType)
            result(polygon?.toJSONFlutter())
            break
        case "intersection":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let firstGeometry = Geometry.fromFlutter(data: data["firstGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = Geometry.fromFlutter(data: data["secondGeometry"] as! Dictionary<String, Any>)!
            let geometry = GeometryEngine.intersection(firstGeometry, secondGeometry)
            result(geometry?.toJSONFlutter())
            break
        case "intersections":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result([] as Any)
                return
            }
            let firstGeometry = Geometry.fromFlutter(data: data["firstGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = Geometry.fromFlutter(data: data["secondGeometry"] as! Dictionary<String, Any>)!
            guard let geometryList = GeometryEngine.intersections(ofGeometry1: firstGeometry, geometry2: secondGeometry) else {
                result([])
                return
            }
            var geometryResults: [Any] = []
            geometryList.forEach { any in
                if let geometry = any as? Geometry {
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
            let firstGeometry = Geometry.fromFlutter(data: data["containerGeometry"] as! Dictionary<String, Any>)!
            let secondGeometry = Geometry.fromFlutter(data: data["withinGeometry"] as! Dictionary<String, Any>)!
            result(GeometryEngine.doesGeometry(firstGeometry, contain: secondGeometry))
            break
        case "geodesicSector":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let params = GeodesicSectorParameters(data: data)
            let geometry = GeometryEngine.geodesicSector(parameters: params)
            result(geometry?.toJSONFlutter())
            break
        case "geodeticMove":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let points = (data["points"] as! [Dictionary<String, Any>]).map {
                Point(data: $0)
            }
            let distance = data["distance"] as! Double
            let distanceUnitId = LinearUnit(flutterValue:data["distanceUnit"] as! Int)
            let azimuth = data["azimuth"] as! Double
            let azimuthUnitId = AGSAngularUnitID.fromFlutter(data["azimuthUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType( data["curveType"] as! Int)!
            let results = GeometryEngine.geodeticMove(points,
                    distance: distance,
                    distanceUnit: LinearUnit(unitID: distanceUnitId)!,
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
            guard let originGeomtry = Geometry.fromFlutter(data: geometryData) else {
                result(nil)
                return
            }
            let simplifiedGeomtry = GeometryEngine.simplify(originGeomtry)
            result(simplifiedGeomtry?.toJSONFlutter())
            break
        case "isSimple":
            guard let geometryData = call.arguments as? Dictionary<String, Any> else {
                result(true)
                return
            }
            guard let originGeomtry = Geometry.fromFlutter(data: geometryData) else {
                result(true)
                return
            }
            result(GeometryEngine.geometryIsSimple(originGeomtry))
            break
        case "densifyGeodetic":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let maxSegmentLength = data["maxSegmentLength"] as! Double
            let lengthUnitId = LinearUnit(flutterValue:data["lengthUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType( data["curveType"] as! Int)!
            let resultGeomtry = GeometryEngine.geodeticDensifyGeometry(geometry, maxSegmentLength: maxSegmentLength , lengthUnit: AGSLinearUnit(unitID: lengthUnitId)!, curveType: curveType)
            result(resultGeomtry?.toJSONFlutter())
            break
        case "lengthGeodetic":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let lengthUnitId = LinearUnit(flutterValue:data["lengthUnit"] as! Int)
            let curveType =GeometryEngine.GeodeticCurveType( data["curveType"] as! Int)!
            result(GeometryEngine.geodeticLength(of: geometry, lengthUnit: AGSLinearUnit(unitID: lengthUnitId)!, curveType: curveType))
            break
        case "areaGeodetic":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            let areaUnitId = AGSAreaUnitID.fromFlutter(data["areaUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType( data["curveType"] as! Int)!
    
            result(GeometryEngine.geodeticArea(of: geometry, areaUnit:AGSAreaUnit(unitID: areaUnitId)!, curveType: curveType))
            break
        case "getExtent":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
            result(geometry.extent.toJSONFlutter())
            break

        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
