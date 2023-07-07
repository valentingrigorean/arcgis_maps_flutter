package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.arcgismaps.mapping.layers.Layer
import com.arcgismaps.tasks.tilecache.ExportTileCacheTask
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.tilecache.toExportTileCacheParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.tilecache.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.util.UUID

class ExportTileCacheTaskNativeObject(objectId: String, exportTileCacheTask: ExportTileCacheTask) :
    BaseNativeObject<ExportTileCacheTask>(
        objectId, exportTileCacheTask, arrayOf(
            LoadableNativeHandler(exportTileCacheTask),
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
       scope.launch {
           val data =  args as Map<*, *>
           val areaOfInterest = data["areaOfInterest"]?.toGeometryOrNull()!!
           val minScale =  data["minScale"] as Double
           val maxScale = data["maxScale"] as Double
           nativeObject.createDefaultExportTileCacheParameters(
               areaOfInterest,
               minScale,
               maxScale
           ).onSuccess {
               result.success(it.toFlutterJson())
           }.onFailure {
               result.success(it.toFlutterJson())
           }
       }
    }

    private fun estimateTileCacheSizeJob(args: Any?, result: MethodChannel.Result) {
        val parameters = args?.toExportTileCacheParametersOrNull()!!
        val job = nativeObject.createEstimateTileCacheSizeJob(parameters)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject =
            EstimateTileCacheSizeJobNativeObjectNativeObject(jobId, job, getMessageSink())
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }

    private fun exportTileCacheJob(args: Any?, result: MethodChannel.Result) {
        val data = args as Map<*, *>
        val parameters = data["parameters"]?.toExportTileCacheParametersOrNull()!!
        val fileNameWithPath = data["fileNameWithPath"] as String
        val job = nativeObject.createExportTileCacheJob(parameters, fileNameWithPath)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = ExportTileCacheJobNativeObject(jobId, job, getMessageSink())
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}