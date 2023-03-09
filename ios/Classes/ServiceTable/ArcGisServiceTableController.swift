//
//  ArcGisServiceTable.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Flutter
import ArcGIS

class ArcGisServiceTableController {
    private let messenger: FlutterBinaryMessenger
    private let methodChannel: FlutterMethodChannel
    private var serviceTables: [AGSServiceFeatureTable] = []

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        methodChannel = FlutterMethodChannel(name: "plugins.flutter.io/service_table", binaryMessenger: messenger)
        methodChannel.setMethodCallHandler(handle)
    }

    deinit {
        methodChannel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch call.method {
        case "queryFeatures":
            queryFeatures(call, result: result)
            break
        case "queryFeatureCount":
            queryCount(call, result: result)
            break
        case "queryStatisticsAsync":
            queryStatisticsAsync(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
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


        guard let queryParameterMap = data["queryParameters"] as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        let whereClause: String? = queryParameterMap["whereClause"] as? String


        let geometryParam: Dictionary<String, Any>? = queryParameterMap["geometry"] as? Dictionary<String, Any>
        let spatialRelationShipPayload = queryParameterMap["spatialRelationship"] as? Int
        var spatialRelationShipParam: AGSSpatialRelationship? = nil
        
        if let sp = spatialRelationShipPayload{
            spatialRelationShipParam = AGSSpatialRelationship.fromFlutter(sp)
        }
        
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

//        [weak self]
        let serviceTable: AGSServiceFeatureTable = AGSServiceFeatureTable(url: url)
        serviceTables.append(serviceTable)
        serviceTable.queryFeatures(with: query, queryFeatureFields: queryFeatureFields) { [weak self](queryResult, error) in
            if let index = self?.serviceTables.firstIndex(of: serviceTable) {
                self?.serviceTables.remove(at: index)
            }
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

    private func queryStatisticsAsync(_ call: FlutterMethodCall,
                                      result: @escaping FlutterResult) {

        let emptyResult: Dictionary<String, [Dictionary<String, Any>]> = ["results": [Dictionary<String, Any>]()]
        guard let data = call.arguments as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        guard let url = URL(string: data["url"] as! String) else {
            result(emptyResult)
            return
        }


        guard let queryParametersMap = data["statisticsQueryParameters"] as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        let whereClause: String? = queryParametersMap["whereClause"] as? String

        let geometryParam: Dictionary<String, Any>? = queryParametersMap["geometry"] as? Dictionary<String, Any>
  
        let spatialRelationShipPayload = queryParametersMap["spatialRelationship"] as? Int
        var spatialRelationShipParam: AGSSpatialRelationship? = nil
        if let sp = spatialRelationShipPayload{
            spatialRelationShipParam = AGSSpatialRelationship.fromFlutter(sp)
        }

        let groupByFieldNamesParam: Array<String> = (queryParametersMap["groupByFieldNames"] as? Array<String> ?? [String]())

        let orderByFieldsParam = (queryParametersMap["orderByFields"] as? Array<Dictionary<String, String>> ?? []).map { e in
            var sortOrder: AGSSortOrder
            switch (e["sortOrder"]) {
            case "ASCENDING":
                sortOrder = AGSSortOrder.ascending
                break
            case "DESCENDING":
                sortOrder = AGSSortOrder.descending
                break
            default:
                sortOrder = AGSSortOrder.ascending
                break
            }
            return AGSOrderBy(fieldName: e["fieldName"] ?? "", sortOrder: sortOrder)
        }

        let statisticDefinitionsParam = (queryParametersMap["statisticDefinitions"] as? [Dictionary<String, String>] ?? [Dictionary<String, String>]()).map { dictionary -> AGSStatisticDefinition in
            AGSStatisticDefinition(onFieldName: dictionary["fieldName"] ?? "", statisticType:         AGSStatisticType.fromFlutter(dictionary["statisticType"]),
                                   outputAlias: dictionary["outputAlias"])
        }

        let statisticsQueryParameters = AGSStatisticsQueryParameters(statisticDefinitions: statisticDefinitionsParam)
        

        if let w = whereClause {
            statisticsQueryParameters.whereClause = w
        }

        if let g = geometryParam {
            statisticsQueryParameters.geometry = AGSGeometry.fromFlutter(data: g)
        }

        if let srsp = spatialRelationShipParam {
            statisticsQueryParameters.spatialRelationship = srsp
        }

        statisticsQueryParameters.groupByFieldNames.append(contentsOf: groupByFieldNamesParam)
        statisticsQueryParameters.orderByFields.append(contentsOf: orderByFieldsParam)

        let serviceTable: AGSServiceFeatureTable = AGSServiceFeatureTable(url: url)
        serviceTables.append(serviceTable)

        serviceTable.queryStatistics(with: statisticsQueryParameters) { [weak self](queryResult, error) in
            if let index = self?.serviceTables.firstIndex(of: serviceTable) {
                self?.serviceTables.remove(at: index)
            }
            if error != nil {
                result(emptyResult)
            } else {
                guard let statistics = queryResult?.statisticRecordEnumerator().allObjects else {
                    result(emptyResult)
                    return
                }

                var resultRecords: [[String: Any]] = [[String: Any]]();

                statistics.forEach { record in
                    var group: Dictionary<String, Any> = [String: Any]();
                    record.group.forEach { key, value in
                        if (value is String || value is NSNumber) {
                            group[key] = value
                        }
                    }

                    var stat: Dictionary<String, Any> = [String: Any]();
                    record.statistics.forEach { key, value in
                        if (value is String || value is NSNumber) {
                            stat[key] = value
                        }
                    }
                    resultRecords.append([
                        "group": group,
                        "statistics": stat
                    ])
                }

                result(["results": resultRecords])

            }
        }

    }


    private func queryCount(_ call: FlutterMethodCall,
                               result: @escaping FlutterResult) {
        let emptyResult: Dictionary<String, NSNumber> = ["count": 0]
        guard let data = call.arguments as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        guard let url = URL(string: data["url"] as! String) else {
            result(emptyResult)
            return
        }


        guard let queryParameterMap = data["queryParameters"] as? Dictionary<String, Any> else {
            result(emptyResult)
            return
        }

        let whereClause: String? = queryParameterMap["whereClause"] as? String


        let geometryParam: Dictionary<String, Any>? = queryParameterMap["geometry"] as? Dictionary<String, Any>

        let spatialRelationShipPayload = queryParameterMap["spatialRelationship"] as? Int
        var spatialRelationShipParam: AGSSpatialRelationship? = nil
        if let sp = spatialRelationShipPayload{
            spatialRelationShipParam = AGSSpatialRelationship.fromFlutter(sp)
        }


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


//        [weak self]
        let serviceTable: AGSServiceFeatureTable = AGSServiceFeatureTable(url: url)
        serviceTables.append(serviceTable)
        serviceTable.queryFeatureCount(with: query) { [weak self](queryResult, error) in
            if let index = self?.serviceTables.firstIndex(of: serviceTable) {
                self?.serviceTables.remove(at: index)
            }

            if error != nil {
                result(emptyResult)
            } else {
                result(["count": queryResult])
            }
        }
    }
}
