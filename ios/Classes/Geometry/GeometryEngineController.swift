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
            let data = call.arguments as! [String: Any]
            let spatialReference = SpatialReference(data: data["spatialReference"] as! [String: Any])!
            guard let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any]) else {
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
            let data = call.arguments as! [String: Any]             
            let point1 = Point(data: data["point1"] as! [String: Any])
            let point2 = Point(data: data["point2"] as! [String: Any])
            let distanceUnit = LinearUnit(data["distanceUnitId"] as! Int)
            let azimuthUnit = AngularUnit(data["azimuthUnitId"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            let geodeticDistanceResult = GeometryEngine.geodeticDistance(from: point1, to: point2, distanceUnit: distanceUnit, azimuthUnit: azimuthUnit, curveType: curveType)
            result(geodeticDistanceResult?.toJSONFlutter())
        case "bufferGeometry":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            let distance = data["distance"] as! Double
            let polygon = GeometryEngine.buffer(around: geometry, distance: distance)
            result(polygon?.toJSONFlutter())
            break
        case "geodeticBufferGeometry":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            let distance = data["distance"] as! Double
            let distanceUnit = LinearUnit(data["distanceUnit"] as! Int)
            let maxDeviation = data["maxDeviation"] as! Double
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            let polygon = GeometryEngine.geodeticBuffer(around: geometry, distance: distance, distanceUnit: distanceUnit, maxDeviation: maxDeviation, curveType: curveType)
            result(polygon?.toJSONFlutter())
            break
        case "intersection":
            let data = call.arguments as! [String: Any]
            let firstGeometry = Geometry.fromFlutter(data: data["firstGeometry"] as! [String: Any])!
            let secondGeometry = Geometry.fromFlutter(data: data["secondGeometry"] as! [String: Any])!
            let geometry = GeometryEngine.intersection(firstGeometry, secondGeometry)
            result(geometry?.toJSONFlutter())
            break
        case "intersections":
            guard let data = call.arguments as? [String: Any] else {
                result([] as Any)
                return
            }
            let firstGeometry = Geometry.fromFlutter(data: data["firstGeometry"] as! [String: Any])!
            let secondGeometry = Geometry.fromFlutter(data: data["secondGeometry"] as! [String: Any])!
            let geometryList = GeometryEngine.intersections(firstGeometry, secondGeometry)
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
            guard let data = call.arguments as? [String: Any] else {
                result(false)
                return
            }
            let firstGeometry = Geometry.fromFlutter(data: data["containerGeometry"] as! [String: Any])!
            let secondGeometry = Geometry.fromFlutter(data: data["withinGeometry"] as! [String: Any])!
            result(GeometryEngine.doesGeometry(firstGeometry, contain: secondGeometry))
            break
        case "geodesicSector":
            let data = call.arguments as! [String: Any]
            let params = GeodesicSectorParameters.createGeodesicSectorParameters(data: data)
            let geometry = GeometryEngine.geodesicSector(parameters: params)
            result(geometry?.toJSONFlutter())
            break
        case "geodeticMove":
            let data = call.arguments as! [String: Any]
            let points = (data["points"] as! [[String: Any]]).map {
                Point(data: $0)
            }
            let distance = data["distance"] as! Double
            let distanceUnit = LinearUnit(data["distanceUnit"] as! Int)
            let azimuth = data["azimuth"] as! Double
            let azimuthUnit = AngularUnit(data["azimuthUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            let results = GeometryEngine.geodeticMove(points,
                    distance: distance,
                    distanceUnit: distanceUnit,
                    azimuth: azimuth,
                    azimuthUnit: azimuthUnit,
                    curveType: curveType
            )
            result(results.map {
                $0.toJSONFlutter()
            })
            break
        case "simplify":
            guard let geometryData = call.arguments as? [String: Any] else {
                result(nil)
                return
            }
            guard let originGeometry = Geometry.fromFlutter(data: geometryData) else {
                result(nil)
                return
            }
            let simplifiedGeometry = GeometryEngine.simplify(originGeometry)
            result(simplifiedGeometry?.toJSONFlutter())
            break
        case "isSimple":
            guard let geometryData = call.arguments as? [String: Any] else {
                result(true)
                return
            }
            guard let originGeometry = Geometry.fromFlutter(data: geometryData) else {
                result(true)
                return
            }
            result(GeometryEngine.isSimple(originGeometry))
            break
        case "densifyGeodetic":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            let maxSegmentLength = data["maxSegmentLength"] as! Double
            let lengthUnit = LinearUnit(data["lengthUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            let resultGeometry = GeometryEngine.geodeticDensify(geometry, maxSegmentLength: maxSegmentLength, lengthUnit:lengthUnit, curveType: curveType)
            result(resultGeometry?.toJSONFlutter())
            break
        case "lengthGeodetic":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            let lengthUnit = LinearUnit(data["lengthUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)
            result(GeometryEngine.geodeticLength(of: geometry, lengthUnit: lengthUnit, curveType: curveType))
            break
        case "areaGeodetic":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            let areaUnit = AreaUnit(flutterValue: data["areaUnit"] as! Int)
            let curveType = GeometryEngine.GeodeticCurveType(data["curveType"] as! Int)

            result(GeometryEngine.geodeticArea(of: geometry, unit: areaUnit, curveType: curveType))
            break
        case "getExtent":
            let data = call.arguments as! [String: Any]
            let geometry = Geometry.fromFlutter(data: data["geometry"] as! [String: Any])!
            result(geometry.extent.toJSONFlutter())
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
