package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis

import android.util.Log
import com.arcgismaps.tasks.networkanalysis.RouteTask
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis.ConvertRouteTask
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class RouteTaskNativeObject(objectId: String, task: RouteTask) : BaseNativeObject<RouteTask>(
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
        scope.launch {
            nativeObject.load().onSuccess {
                result.success(nativeObject.getRouteTaskInfo().toFlutterJson())
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun createDefaultParameters(result: MethodChannel.Result) {
        scope.launch {
            nativeObject.createDefaultParameters().onSuccess {
                result.success(it.toFlutterJson())
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun solveRoute(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val routeParameters = ConvertRouteTask.toRouteParameters(
                args!!
            )
            val future = nativeObject.solveRoute(routeParameters)
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
    }

    companion object {
        val TAG: String = RouteTaskNativeObject::class.java.simpleName!!
    }
}