package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.esri.arcgisruntime.concurrent.ListenableFuture
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapParameters
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapTask
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class OfflineMapTaskNativeObject(objectId: String?, task: OfflineMapTask) :
    BaseNativeObject<OfflineMapTask?>(
        objectId, task, arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
            RemoteResourceNativeHandler(task)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "offlineMapTask#defaultGenerateOfflineMapParameters" -> {
                defaultGenerateOfflineMapParameters(
                    Convert.Companion.toMap(
                        args!!
                    ), result
                )
            }

            "offlineMapTask#generateOfflineMap" -> {
                generateOfflineMap(
                    Convert.Companion.toMap(
                        args!!
                    ), result
                )
            }

            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun defaultGenerateOfflineMapParameters(data: Map<*, *>, result: MethodChannel.Result) {
        val areaOfInterest: Geometry = Convert.Companion.toGeometry(
            data["areaOfInterest"]
        )
        val minScale = data["minScale"]
        val maxScale = data["maxScale"]
        val future: ListenableFuture<GenerateOfflineMapParameters>
        future = if (minScale == null) {
            nativeObject.createDefaultGenerateOfflineMapParametersAsync(areaOfInterest)
        } else {
            nativeObject.createDefaultGenerateOfflineMapParametersAsync(
                areaOfInterest,
                minScale as Double,
                maxScale as Double
            )
        }
        future.addDoneListener {
            try {
                val parameters = future.get()
                result.success(ConvertOfflineMap.generateOfflineMapParametersToJson(parameters))
            } catch (e: Exception) {
                result.error("defaultGenerateOfflineMapParameters", e.message, null)
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