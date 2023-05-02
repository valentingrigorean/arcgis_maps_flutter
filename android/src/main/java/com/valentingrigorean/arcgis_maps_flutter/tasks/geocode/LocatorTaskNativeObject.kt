package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode

import com.arcgismaps.tasks.geocode.LocatorTask
import com.arcgismaps.tasks.geocode.SuggestResult
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode.toGeocodeParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode.toReverseGeocodeParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode.toSuggestParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.util.UUID

class LocatorTaskNativeObject(objectId: String, task: LocatorTask) :
    BaseNativeObject<LocatorTask>(
        objectId,
        task,
        arrayOf(
            LoadableNativeHandler(task),
            ApiKeyResourceNativeHandler(task)
        )
    ) {
    private val suggestResultsMap: MutableMap<String, SuggestResult> = HashMap()
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "locatorTask#getLocatorInfo" -> getLocatorInfo(result)
            "locatorTask#geocode" -> geocode(args, result)
            "locatorTask#geocodeSuggestResult" -> geocodeSuggestResult(args, result)
            "locatorTask#geocodeSearchValues" -> geocodeSearchValues(args, result)
            "locatorTask#reverseGeocode" -> reverseGeocode(args, result)
            "locatorTask#suggest" -> suggest(args, result)
            "locatorTask#releaseSuggestResults" -> {
                releaseSuggestResults(args)
                result.success(null)
            }

            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun getLocatorInfo(result: MethodChannel.Result) {
        scope.launch {
            nativeObject.load().onSuccess {
                result.success(nativeObject.locatorInfo?.toFlutterJson())
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun geocode(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val data: Map<*, *> = args as Map<*, *>
            val searchText = data["searchText"].toString()
            val parameters = data["parameters"]?.toGeocodeParametersOrNull()
            nativeObject.geocode(searchText, parameters).onSuccess { results ->
                result.success(results.map { it.toFlutterJson() })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun geocodeSuggestResult(args: Any?, result: MethodChannel.Result) {
        val data = args as Map<*, *>
        val tag = data["suggestResultId"].toString()
        val suggestResult = suggestResultsMap[tag]
        if (suggestResult == null) {
            result.error("ERROR", "SuggestResult not found", null)
            return
        }
        scope.launch {
            val parameters = data["parameters"]?.toGeocodeParametersOrNull()
            nativeObject.geocode(suggestResult, parameters).onSuccess { results ->
                result.success(results.map { it.toFlutterJson() })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun geocodeSearchValues(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val data = args as Map<*, *>
            val searchValues = data["searchValues"] as Map<String, String>
            val parameters = data["parameters"]?.toGeocodeParametersOrNull()
            nativeObject.geocode(searchValues, parameters).onSuccess { results ->
                result.success(results.map { it.toFlutterJson() })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun reverseGeocode(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val data = args as Map<*, *>
            val location = data["location"]?.toPointOrNull()
            val parameters = data["parameters"]?.toReverseGeocodeParametersOrNull()
            nativeObject.reverseGeocode(location!!, parameters).onSuccess { results ->
                result.success(results.map { it.toFlutterJson() })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun suggest(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val data = args as Map<*, *>
            val searchText = data["searchText"].toString()
            val parameters = data["parameters"]?.toSuggestParametersOrNull()
            nativeObject.suggest(searchText, parameters).onSuccess { results ->
                result.success(results.map {
                    val tag = UUID.randomUUID().toString()
                    suggestResultsMap[tag] = it
                    return@map it.toFlutterJson(tag)
                })
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun releaseSuggestResults(args: Any?) {
        if (args == null) {
            suggestResultsMap.clear()
            return
        }
        val tags = args as List<String>
        for (tag in tags) {
            suggestResultsMap.remove(tag)
        }
    }
}