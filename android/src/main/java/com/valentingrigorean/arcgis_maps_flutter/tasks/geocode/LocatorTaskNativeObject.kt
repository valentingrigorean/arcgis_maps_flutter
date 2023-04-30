package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode

import android.util.Log
import com.arcgismaps.tasks.geocode.LocatorTask
import com.arcgismaps.tasks.geocode.SuggestResult
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class LocatorTaskNativeObject(objectId: String, task: LocatorTask) :
    BaseNativeObject<LocatorTask>(
        objectId,
        task,
        arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
            RemoteResourceNativeHandler(task),
            ApiKeyResourceNativeHandler(task)
        )
    ) {
    private val suggestResultsMap: MutableMap<String, SuggestResult> = HashMap()
    override fun disposeInternal() {
        super.disposeInternal()
        suggestResultsMap.clear()
    }

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
        val locatorTask = nativeObject
        if (locatorTask!!.loadStatus != LoadStatus.LOADED) {
            locatorTask.loadAsync()
        }
        locatorTask.addDoneLoadingListener {
            if (locatorTask.loadStatus == LoadStatus.LOADED) {
                result.success(ConvertLocatorTask.locatorInfoToJson(locatorTask.locatorInfo))
            } else {
                val exception = locatorTask.loadError
                result.error(
                    "ERROR",
                    if (exception != null) exception.message else "Unknown error.",
                    null
                )
            }
        }
    }

    private fun geocode(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val searchText = data["searchText"].toString()
        val parameters = data["parameters"]
        val future: ListenableFuture<List<GeocodeResult>>
        future = if (parameters == null) {
            nativeObject.geocodeAsync(searchText)
        } else {
            nativeObject.geocodeAsync(
                searchText,
                ConvertLocatorTask.toGeocodeParameters(parameters)
            )
        }
        future.addDoneListener {
            try {
                val geocodeResults = future.get()
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults))
            } catch (e: Exception) {
                Log.e(TAG, "geocode: ", e)
                result.error("ERROR", e.message, null)
            }
        }
    }

    private fun geocodeSuggestResult(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val tag = data["suggestResultId"].toString()
        val suggestResult = suggestResultsMap[tag]
        if (suggestResult == null) {
            result.error("ERROR", "SuggestResult not found", null)
            return
        }
        val parameters = data["parameters"]
        val future: ListenableFuture<List<GeocodeResult>>
        future = if (parameters == null) {
            nativeObject.geocodeAsync(suggestResult)
        } else {
            nativeObject.geocodeAsync(
                suggestResult,
                ConvertLocatorTask.toGeocodeParameters(parameters)
            )
        }
        future.addDoneListener {
            try {
                val geocodeResults = future.get()
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults))
            } catch (e: Exception) {
                Log.e(TAG, "geocode: ", e)
                result.error("ERROR", e.message, null)
            }
        }
    }

    private fun geocodeSearchValues(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val searchValues = Convert.Companion.toMap(
            data["searchValues"]!!
        ) as Map<String, String>
        val parameters = data["parameters"]
        val future: ListenableFuture<List<GeocodeResult>>
        future = if (parameters == null) {
            nativeObject.geocodeAsync(searchValues)
        } else {
            nativeObject.geocodeAsync(
                searchValues,
                ConvertLocatorTask.toGeocodeParameters(parameters)
            )
        }
        future.addDoneListener {
            try {
                val geocodeResults = future.get()
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults))
            } catch (e: Exception) {
                Log.e(TAG, "geocode: ", e)
                result.error("ERROR", e.message, null)
            }
        }
    }

    private fun reverseGeocode(args: Any?, result: MethodChannel.Result) {
        val locatorTask = nativeObject
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val location: Point = Convert.Companion.toPoint(
            data["location"]
        )
        val parameters = data["parameters"]
        val future: ListenableFuture<List<GeocodeResult>>
        future = if (parameters == null) {
            locatorTask!!.reverseGeocodeAsync(location)
        } else {
            locatorTask!!.reverseGeocodeAsync(
                location,
                ConvertLocatorTask.toReverseGeocodeParameters(parameters)
            )
        }
        future.addDoneListener {
            try {
                val results = future.get()
                result.success(ConvertLocatorTask.geocodeResultsToJson(results))
            } catch (e: Exception) {
                Log.e(TAG, "reverseGeocode: Failed to reverse geocode", e)
                result.error("ERROR", "Failed to reverse geocode.", e.message)
            }
        }
    }

    private fun suggest(args: Any?, result: MethodChannel.Result) {
        val locatorTask = nativeObject
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val searchText = data["searchText"].toString()
        val parameters = data["parameters"]
        val future: ListenableFuture<List<SuggestResult>>
        future = if (parameters == null) {
            locatorTask!!.suggestAsync(searchText)
        } else {
            locatorTask!!.suggestAsync(
                searchText,
                ConvertLocatorTask.toSuggestParameters(parameters)
            )
        }
        future.addDoneListener {
            try {
                val results = future.get()
                result.success(ConvertLocatorTask.suggestResultsToJson(results) { suggestResult: SuggestResult ->
                    val tag = UUID.randomUUID().toString()
                    suggestResultsMap[tag] = suggestResult
                    tag
                })
            } catch (e: Exception) {
                Log.e(TAG, "suggest: Failed to suggest", e)
                result.error("ERROR", "Failed to suggest.", e.message)
            }
        }
    }

    private fun releaseSuggestResults(args: Any?) {
        if (args == null) {
            suggestResultsMap.clear()
            return
        }
        val tags: List<*> = Convert.Companion.toList(args)
        for (tag in tags) {
            suggestResultsMap.remove(tag.toString())
        }
    }

    companion object {
        val TAG = LocatorTaskNativeObject::class.java.simpleName
    }
}