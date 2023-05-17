package com.valentingrigorean.arcgis_maps_flutter.data

import com.arcgismaps.data.ServiceFeatureTable
import com.valentingrigorean.arcgis_maps_flutter.convert.data.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.data.toQueryFeatureFields
import com.valentingrigorean.arcgis_maps_flutter.convert.data.toQueryParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.data.toStatisticsQueryParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class ServiceFeatureTableNativeObject(objectId: String, serviceFeatureTable: ServiceFeatureTable) :
    BaseNativeObject<ServiceFeatureTable>(
        objectId, serviceFeatureTable, arrayOf(
            LoadableNativeHandler(serviceFeatureTable),
            ApiKeyResourceNativeHandler(serviceFeatureTable)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "serviceFeatureTable#queryFeatures" -> {
                queryFeatures(args as Map<*, *>, result)
            }

            "serviceFeatureTable#queryStatistics" -> {
                queryStatistics(args as Map<*, *>, result)
            }

            "serviceFeatureTable#queryFeatureCount" ->{
                scope.launch {
                    val queryParameters = args as Map<*, *>
                    nativeObject.queryFeatureCount(queryParameters.toQueryParametersOrNull()!!)
                        .onSuccess { res -> result.success(res) }
                        .onFailure { result.success(it.toFlutterJson()) }
                }
            }

            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun queryFeatures(args: Map<*, *>, result: MethodChannel.Result) {
        scope.launch {
            val queryParameters = args["queryParameters"]?.toQueryParametersOrNull()!!
            val queryFields = (args["queryFields"] as Int).toQueryFeatureFields()
            nativeObject.queryFeatures(queryParameters, queryFields)
                .onSuccess { res -> result.success(res.map { it.toFlutterJson() }) }
                .onFailure { result.success(it.toFlutterJson()) }
        }

    }

    private fun queryStatistics(args: Map<*, *>, result: MethodChannel.Result) {
        scope.launch {
            val queryParameters = args["queryParameters"]?.toStatisticsQueryParametersOrNull()!!
            nativeObject.queryStatistics(queryParameters).onSuccess { queryResult ->
                result.success(queryResult.map { it.toFlutterJson() })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }
}