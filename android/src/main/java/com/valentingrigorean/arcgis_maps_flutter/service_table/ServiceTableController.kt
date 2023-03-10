package com.valentingrigorean.arcgis_maps_flutter.service_table

import android.util.Log
import com.esri.arcgisruntime.concurrent.ListenableFuture
import com.esri.arcgisruntime.data.*
import com.esri.arcgisruntime.data.QueryParameters.OrderBy
import com.esri.arcgisruntime.geometry.Geometry
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toFlutterType
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import com.valentingrigorean.arcgis_maps_flutter.utils.toStatisticType
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class ServiceTableController(messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    private var channel: MethodChannel =
        MethodChannel(messenger, "plugins.flutter.io/service_table")

    init {
        channel.setMethodCallHandler(this)
    }

    private val listenableResult: MutableList<ListenableFuture<*>> = mutableListOf()
    private val cachedServiceTable: MutableMap<String, ServiceFeatureTable> = mutableMapOf()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "queryFeatures" -> {
                queryFeatures(call, result)
            }
            "queryStatisticsAsync" -> {
                queryStatisticsAsync(call, result)
            }
            "queryFeatureCount" -> {
                queryFeatureCount(call, result)
            }
            else -> {}
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun queryFeatures(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String?>("url").orEmpty()
        val serviceFeatureTable: ServiceFeatureTable?
        if (cachedServiceTable.containsKey(url)) {
            serviceFeatureTable = cachedServiceTable[url]
        } else {
            serviceFeatureTable = ServiceFeatureTable(url)
            cachedServiceTable[url] = serviceFeatureTable
        }
        if (serviceFeatureTable == null) {
            result.error("-999", "can not get sServiceFeatureTable", "url ${url}")
            return
        }

        val queryParametersMap: Map<Any, Any> =
            call.argument<Map<Any, Any>?>("queryParameters").orEmpty()
        val whereClauseParam: String? = queryParametersMap["whereClause"] as String?
        val spatialRelationshipParam: QueryParameters.SpatialRelationship? =
            with(queryParametersMap["spatialRelationship"]) {
                if (this != null) {
                    Convert.toSpatialRelationship(this)
                } else {
                    null
                }
            }

        val geometryParamJson = queryParametersMap["geometry"]

        var geometryParam: Geometry? = null
        if (geometryParamJson != null) {
            geometryParam = Convert.toGeometry(geometryParamJson)
        }

        val query = QueryParameters().apply {
            isReturnGeometry = queryParametersMap["isReturnGeometry"] as Boolean

            if (geometryParam != null) {
                geometry = geometryParam
            }
            maxFeatures = queryParametersMap["maxFeatures"] as Int
            if (whereClauseParam != null) {
                whereClause = whereClauseParam
            }
            if (spatialRelationshipParam != null) {
                spatialRelationship = spatialRelationshipParam
            }
            this.resultOffset = queryParametersMap["resultOffset"] as Int
        }

        val queryFields = when (call.argument<String?>("queryFields")) {
            "IDS_ONLY" -> ServiceFeatureTable.QueryFeatureFields.IDS_ONLY
            "MINIMUM" -> ServiceFeatureTable.QueryFeatureFields.MINIMUM
            "LOAD_ALL" -> ServiceFeatureTable.QueryFeatureFields.LOAD_ALL
            else -> ServiceFeatureTable.QueryFeatureFields.LOAD_ALL
        }
        val future = serviceFeatureTable.queryFeaturesAsync(query, queryFields)
        listenableResult.add(future)
        future.addDoneListener {

            val features = future.get().map {
                it.toMap()
            }.toList()
            listenableResult.remove(future)
            result.success(
                mapOf<String, List<Any>>(
                    "features" to features
                )
            )
        }

    }

    private fun queryFeatureCount(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String?>("url").orEmpty()
        val serviceFeatureTable: ServiceFeatureTable?
        if (cachedServiceTable.containsKey(url)) {
            serviceFeatureTable = cachedServiceTable[url]
        } else {
            serviceFeatureTable = ServiceFeatureTable(url)
            cachedServiceTable[url] = serviceFeatureTable
        }
        if (serviceFeatureTable == null) {
            result.error("-999", "can not get sServiceFeatureTable", "url ${url}")
            return
        }

        val queryParametersMap: Map<Any, Any> =
            call.argument<Map<Any, Any>?>("queryParameters").orEmpty()
        val whereClauseParam: String? = queryParametersMap["whereClause"] as String?
        val spatialRelationshipParam: QueryParameters.SpatialRelationship? =
            with(queryParametersMap["spatialRelationship"]) {
                if (this != null) {
                    Convert.toSpatialRelationship(this)
                } else {
                    null
                }
            }


        val geometryParamJson = queryParametersMap["geometry"]

        var geometryParam: Geometry? = null
        if (geometryParamJson != null) {
            geometryParam = Convert.toGeometry(geometryParamJson)
        }

        val query = QueryParameters().apply {
            isReturnGeometry = queryParametersMap["isReturnGeometry"] as Boolean

            if (geometryParam != null) {
                geometry = geometryParam
            }
            maxFeatures = queryParametersMap["maxFeatures"] as Int
            if (whereClauseParam != null) {
                whereClause = whereClauseParam
            }
            if (spatialRelationshipParam != null) {
                spatialRelationship = spatialRelationshipParam
            }
            this.resultOffset = queryParametersMap["resultOffset"] as Int
        }

        val future = serviceFeatureTable.queryFeatureCountAsync(query)
        listenableResult.add(future)

        future.addDoneListener {
            listenableResult.remove(future)

            val count = future.get()
            result.success(
                mapOf(
                    "count" to count
                )
            )
        }

    }

    private fun queryStatisticsAsync(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String?>("url").orEmpty()
        val serviceFeatureTable: ServiceFeatureTable?
        if (cachedServiceTable.containsKey(url)) {
            serviceFeatureTable = cachedServiceTable[url]
        } else {
            serviceFeatureTable = ServiceFeatureTable(url)
            cachedServiceTable[url] = serviceFeatureTable
        }
        if (serviceFeatureTable == null) {
            result.error("-999", "can not get sServiceFeatureTable", "url ${url}")
            return
        }

        val queryParametersMap: Map<Any, Any> =
            call.argument<Map<Any, Any>?>("statisticsQueryParameters").orEmpty()

        val whereClauseParam: String? = queryParametersMap["whereClause"] as String?

        val spatialRelationshipParam: QueryParameters.SpatialRelationship? =
            with(queryParametersMap["spatialRelationship"]) {
                if (this != null) {
                    Convert.toSpatialRelationship(this)
                } else {
                    null
                }
            }

        val geometryParamJson = queryParametersMap["geometry"]

        var geometryParam: Geometry? = null
        if (geometryParamJson != null) {
            geometryParam = Convert.toGeometry(geometryParamJson)
        }

        val groupByFieldNamesParam =
            (queryParametersMap["groupByFieldNames"] as? List<String>).orEmpty()

        val statisticDefinitionsParam =
            (queryParametersMap["statisticDefinitions"] as? List<Map<String, String>>).orEmpty()
                .map {
                    StatisticDefinition(
                        it["fieldName"],
                        it["statisticType"].toStatisticType(),
                        it["outputAlias"],
                    )
                }.toList()

        val orderByFieldsParam =
            (queryParametersMap["orderByFields"] as? List<Map<String, String>>).orEmpty()
                .map {
                    OrderBy(
                        it["fieldName"],
                        when (it["sortOrder"]) {
                            "ASCENDING" -> QueryParameters.SortOrder.ASCENDING
                            "DESCENDING" -> QueryParameters.SortOrder.DESCENDING
                            else -> throw IllegalArgumentException("unsupported value ${it["sortOrder"]}")
                        }
                    )
                }.toList()

        val statisticsQueryParameters = StatisticsQueryParameters(statisticDefinitionsParam).apply {
            whereClauseParam?.let {
                whereClause = it
            }
            geometryParam?.let {
                geometry = it
            }
            spatialRelationshipParam?.let {
                spatialRelationship = it
            }
            groupByFieldNames.addAll(groupByFieldNamesParam)
            orderByFields.addAll(orderByFieldsParam)
        }

        val statisticsResult = serviceFeatureTable.queryStatisticsAsync(statisticsQueryParameters)
        listenableResult.add(statisticsResult)

        statisticsResult.addDoneListener {
            val realResult = statisticsResult.get()
            listenableResult.remove(statisticsResult)
            val resultRecords: MutableList<Map<String, Any>> = mutableListOf()

            realResult.iterator().forEach {
                val group: MutableMap<String, Any> = mutableMapOf()
                val statistics: MutableMap<String, Any> = mutableMapOf()
                it.group.forEach { (key, value) ->
                    if (value is String || value is Int || value is Short || value is Double || value is Float) {
                        group[key] = value
                    }
                }

                it.statistics.forEach { (key, value) ->
                    if (value is String || value is Int || value is Short || value is Double || value is Float) {
                        statistics[key] = value
                    }
                }

                resultRecords.add(
                    mapOf(
                        "group" to group,
                        "statistics" to statistics
                    )
                )
            }
            result.success(
                mapOf<String, Any>(
                    "results" to resultRecords
                )
            )
        }
    }
}