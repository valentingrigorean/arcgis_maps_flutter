//
//  ArcGisServiceTable.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Flutter
import ArcGIS


class ArcGisServiceTableController {
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        methodChannel.setMethodCallHandler(handle)
    }

    deinit {
        methodChannel.setMethodCallHandler(nil)
    }

    private let methodChannel: FlutterMethodChannel

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch (call.method) {
        case "queryFeatures":
            queryFeatures(call, result: result)
            break
        default:
            break
        }
    }

    private func queryFeatures(_ call: FlutterMethodCall,
                               result: @escaping FlutterResult) {
        let emptyResult: Dictionary<String, Any> = ["features": [Any]()]
        guard let data = call.arguments as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        guard let url = URL(string: data["url"] as! String) else {
            result(emptyResult)
            return
        }

        let whereClause: String? = data["whereClause"] as? String

        guard let queryParameterMap = data["queryParameters"] as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        let geometryParam: Dictionary<String, Any>? = queryParameterMap["geometry"] as? Dictionary<String, Any>
        let spatialRelationShipParam: AGSSpatialRelationship? = strToSpatialRelationShip(string: queryParameterMap["spatialRelationship"] as? String)

        let query = AGSQueryParameters()

        query.returnGeometry = queryParameterMap["isReturnGeometry"] as? Bool ?? true
        query.maxFeatures = queryParameterMap["maxFeatures"] as! Int
        query.resultOffset = queryParameterMap["resultOffset"] as! Int

        if let g = geometryParam {
            query.geometry = AGSGeometry.fromFlutter(data: g)
        }

        if let w = whereClause {
            query.whereClause = w
        }

        if let srsp = spatialRelationShipParam {
            query.spatialRelationship = srsp
        }

        var queryFeatureFields: AGSQueryFeatureFields = AGSQueryFeatureFields.loadAll

        switch (data["url"] as? String) {
        case "IDS_ONLY":
            queryFeatureFields = AGSQueryFeatureFields.idsOnly
            break
        case "MINIMUM":
            queryFeatureFields = AGSQueryFeatureFields.minimum
            break
        case "LOAD_ALL":
            queryFeatureFields = AGSQueryFeatureFields.loadAll
            break
        default:
            break;
        }
        let serviceTable = AGSServiceFeatureTable(url: url)
//        [weak self]
        serviceTable.queryFeatures(with: query, queryFeatureFields: queryFeatureFields) { queryResult, error in
            if error != nil {
                result(emptyResult)
            } else {
                guard let features = queryResult?.featureEnumerator().allObjects else {
                    result(emptyResult)
                    return
                }
                let featuresJson = features.map { feature -> Any in
                    feature.toJSONFlutter()
                }

                result(["features": featuresJson])
            }
        }
    }

    private func strToSpatialRelationShip(string: String?) -> AGSSpatialRelationship? {
        var spatialRelationShipParam: AGSSpatialRelationship? = nil

        switch (string) {

        case "UNKNOWN":
            spatialRelationShipParam = AGSSpatialRelationship.unknown
            break
        case "RELATE":
            spatialRelationShipParam = AGSSpatialRelationship.relate
            break
        case "EQUALS":
            spatialRelationShipParam = AGSSpatialRelationship.equals
            break
        case "DISJOINT":
            spatialRelationShipParam = AGSSpatialRelationship.disjoint
            break
        case "INTERSECTS":
            spatialRelationShipParam = AGSSpatialRelationship.intersects
            break
        case "CROSSES":
            spatialRelationShipParam = AGSSpatialRelationship.crosses
            break
        case "WITHIN":
            spatialRelationShipParam = AGSSpatialRelationship.within
            break
        case "CONTAINS":
            spatialRelationShipParam = AGSSpatialRelationship.contains
            break
        case "OVERLAPS":
            spatialRelationShipParam = AGSSpatialRelationship.overlaps
            break
        case "ENVELOPE_INTERSECTS":
            spatialRelationShipParam = AGSSpatialRelationship.envelopeIntersects
            break
        case "INDEX_INTERSECTS":
            spatialRelationShipParam = AGSSpatialRelationship.indexIntersects
            break
        default:
            spatialRelationShipParam = nil
            break
        }

        return spatialRelationShipParam

    }
}
