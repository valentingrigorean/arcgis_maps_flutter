package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapTask
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.util.UUID

class OfflineMapTaskNativeObject(objectId: String, task: OfflineMapTask) :
    BaseNativeObject<OfflineMapTask>(
        objectId, task, arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "offlineMapTask#defaultGenerateOfflineMapParameters" -> {
                defaultGenerateOfflineMapParameters(
                    args as Map<*, *>, result
                )
            }

            "offlineMapTask#generateOfflineMap" -> {
                generateOfflineMap(
                    args as Map<*, *>, result
                )
            }

            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun defaultGenerateOfflineMapParameters(data: Map<*, *>, result: MethodChannel.Result) {
        scope.launch {
            val areaOfInterest = data["areaOfInterest"]?.toGeometryOrNull()!!
            val minScale = data["minScale"] as Double?
            val maxScale = data["maxScale"] as Double?
            if (minScale == null) {
                nativeObject.createDefaultGenerateOfflineMapParameters(areaOfInterest)
            } else {
                nativeObject.createDefaultGenerateOfflineMapParameters(
                    areaOfInterest,
                    minScale,
                    maxScale!!
                )
            }.onSuccess {
                result.success(it.toFlutterJson())
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun generateOfflineMap(data: Map<*, *>, result: MethodChannel.Result) {
        val parameters = ConvertOfflineMap.toGenerateOfflineMapParameters(data["parameters"])
        val downloadDirectory = data["downloadDirectory"] as String?
        val offlineMapJob = nativeObject.generateOfflineMap(parameters, downloadDirectory)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = GenerateOfflineMapJobNativeObject(jobId, offlineMapJob)
        jobNativeObject.setMessageSink(messageSink)
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}