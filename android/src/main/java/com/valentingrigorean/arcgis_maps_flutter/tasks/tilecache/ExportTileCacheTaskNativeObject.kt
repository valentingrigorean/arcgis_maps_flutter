package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheTask
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class ExportTileCacheTaskNativeObject(objectId: String?, exportTileCacheTask: ExportTileCacheTask) :
    BaseNativeObject<ExportTileCacheTask?>(
        objectId, exportTileCacheTask, arrayOf<NativeHandler>(
            LoadableNativeHandler(exportTileCacheTask),
            RemoteResourceNativeHandler(exportTileCacheTask),
            ApiKeyResourceNativeHandler(exportTileCacheTask)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "exportTileCacheTask#createDefaultExportTileCacheParameters" -> createDefaultExportTileCacheParameters(
                args,
                result
            )

            "exportTileCacheTask#estimateTileCacheSizeJob" -> estimateTileCacheSizeJob(args, result)
            "exportTileCacheTask#exportTileCacheJob" -> exportTileCacheJob(args, result)
            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun createDefaultExportTileCacheParameters(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val areaOfInterest: Geometry = Convert.Companion.toGeometry(
            data["areaOfInterest"]
        )
        val minScale: Double = Convert.Companion.toDouble(
            data["minScale"]
        )
        val maxScale: Double = Convert.Companion.toDouble(
            data["maxScale"]
        )
        val future = nativeObject.createDefaultExportTileCacheParametersAsync(
            areaOfInterest,
            minScale,
            maxScale
        )
        future.addDoneListener {
            try {
                result.success(ConvertTileCache.exportTileCacheParametersToJson(future.get()))
            } catch (e: Exception) {
                result.error("createDefaultExportTileCacheParameters", e.message, null)
            }
        }
    }

    private fun estimateTileCacheSizeJob(args: Any?, result: MethodChannel.Result) {
        val parameters = ConvertTileCache.toExportTileCacheParameters(args)
        val job = nativeObject.estimateTileCacheSize(parameters)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject =
            EstimateTileCacheSizeJobNativeObjectNativeObject(jobId, job, messageSink)
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }

    private fun exportTileCacheJob(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val parameters = ConvertTileCache.toExportTileCacheParameters(data["parameters"])
        val fileNameWithPath = data["fileNameWithPath"] as String?
        val job = nativeObject.exportTileCache(parameters, fileNameWithPath)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = ExportTileCacheJobNativeObject(jobId, job, messageSink)
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}