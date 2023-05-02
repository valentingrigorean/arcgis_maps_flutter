package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis

import android.util.Log
import com.arcgismaps.tasks.networkanalysis.RouteTask
import com.esri.arcgisruntime.loadable.LoadStatus
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel

class RouteTaskNativeObject(objectId: String, task: RouteTask) : BaseNativeObject<RouteTask?>(
    objectId,
    task,
    arrayOf<NativeHandler>(
        LoadableNativeHandler(task),
        ApiKeyResourceNativeHandler(task)
    )
) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "routeTask#getRouteTaskInfo" -> getRouteTaskInfo(result)
            "routeTask#createDefaultParameters" -> createDefaultParameters(result)
            "routeTask#solveRoute" -> solveRoute(args, result)
            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun getRouteTaskInfo(result: MethodChannel.Result) {
        val routeTask = nativeObject
        routeTask!!.loadAsync()
        routeTask.addDoneLoadingListener {
            if (routeTask.loadStatus == LoadStatus.LOADED) {
                result.success(ConvertRouteTask.routeTaskInfoToJson(routeTask.routeTaskInfo))
            } else if (routeTask.loadStatus == LoadStatus.FAILED_TO_LOAD) {
                val exception = routeTask.loadError
                result.error(
                    "ERROR",
                    if (exception != null) exception.message else "Unknown error.",
                    null
                )
            }
        }
    }

    private fun createDefaultParameters(result: MethodChannel.Result) {
        val future = nativeObject.createDefaultParametersAsync()
        future.addDoneListener {
            try {
                val routeParameters = future.get()
                result.success(ConvertRouteTask.routeParametersToJson(routeParameters))
            } catch (e: Exception) {
                Log.e(TAG, "Failed to create default parameters.", e)
                result.error("ERROR", "Failed to create default parameters.", e.message)
            }
        }
    }

    private fun solveRoute(args: Any?, result: MethodChannel.Result) {
        val routeParameters = ConvertRouteTask.toRouteParameters(
            args!!
        )
        val future = nativeObject.solveRouteAsync(routeParameters)
        future.addDoneListener {
            try {
                val routeResult = future.get()
                result.success(ConvertRouteTask.routeResultToJson(routeResult))
            } catch (e: Exception) {
                Log.e(TAG, "Failed to solve route.", e)
                result.error("ERROR", "Failed to solve route.", e.message)
            }
        }
    }

    companion object {
        val TAG = RouteTaskNativeObject::class.java.simpleName
    }
}