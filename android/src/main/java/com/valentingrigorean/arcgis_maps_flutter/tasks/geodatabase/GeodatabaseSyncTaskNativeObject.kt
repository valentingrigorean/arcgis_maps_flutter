package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.arcgismaps.tasks.geodatabase.GeodatabaseSyncTask
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseSyncTask
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseJob
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseParameters
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.data.GeodatabaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class GeodatabaseSyncTaskNativeObject(objectId: String, task: GeodatabaseSyncTask) :
    BaseNativeObject<GeodatabaseSyncTask?>(
        objectId, task, arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
            RemoteResourceNativeHandler(task),
            ApiKeyResourceNativeHandler(task)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "geodatabaseSyncTask#defaultGenerateGeodatabaseParameters" -> defaultGenerateGeodatabaseParameters(
                args,
                result
            )

            "geodatabaseSyncTask#importDelta" -> importDelta(args, result)
            "geodatabaseSyncTask#generateJob" -> generateJob(args, result)
            "geodatabaseSyncTask#defaultSyncGeodatabaseParameters" -> defaultSyncGeodatabaseParameters(
                args,
                result
            )

            "geodatabaseSyncTask#syncJob" -> syncJob(args, result)
            "geodatabaseSyncTask#syncJobWithSyncDirection" -> syncJobWithSyncDirection(args, result)
            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun defaultGenerateGeodatabaseParameters(args: Any?, result: MethodChannel.Result) {
        val areaOfInterest: Geometry = Convert.Companion.toGeometry(args)
        val future = nativeObject.createDefaultGenerateGeodatabaseParametersAsync(areaOfInterest)
        future.addDoneListener {
            try {
                result.success(ConvertGeodatabase.generateGeodatabaseParametersToJson(future.get()))
            } catch (e: Exception) {
                result.error("defaultGenerateGeodatabaseParameters", e.message, null)
            }
        }
    }

    private fun importDelta(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val deltaFilePath = data["deltaFilePath"] as String?
        val geodatabaseId = data["geodatabase"] as String?
        val geodatabase =
            nativeObjectStorage.getNativeObject(geodatabaseId) as GeodatabaseNativeObject
        val future = GeodatabaseSyncTask.importDeltaAsync(geodatabase.nativeObject, deltaFilePath)
        future.addDoneListener {
            try {
                result.success(ConvertGeodatabase.syncLayerResultsToJson(future.get()))
            } catch (e: Exception) {
                result.success(null)
            }
        }
    }

    private fun generateJob(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val parameters = ConvertGeodatabase.toGenerateGeodatabaseParameters(data["parameters"])
        val fileNameWithPath = data["fileNameWithPath"] as String?
        val job = nativeObject.generateGeodatabase(parameters, fileNameWithPath)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = GenerateGeodatabaseJobNativeObject(jobId, job, messageSink)
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }

    private fun defaultSyncGeodatabaseParameters(args: Any?, result: MethodChannel.Result) {
        val geodatabaseId = (args as String?)!!
        val geodatabase =
            nativeObjectStorage.getNativeObject(geodatabaseId) as GeodatabaseNativeObject
        val future =
            nativeObject.createDefaultSyncGeodatabaseParametersAsync(geodatabase.nativeObject)
        future.addDoneListener {
            try {
                result.success(ConvertGeodatabase.syncGeodatabaseParametersToJson(future.get()))
            } catch (e: Exception) {
                result.success(Convert.Companion.exceptionToJson(e))
            }
        }
    }

    private fun syncJob(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val parameters = ConvertGeodatabase.toSyncGeodatabaseParameters(data["parameters"])
        val geodatabaseId = data["geodatabase"] as String?
        val geodatabase =
            nativeObjectStorage.getNativeObject(geodatabaseId) as GeodatabaseNativeObject
        val job = nativeObject.syncGeodatabase(parameters, geodatabase.nativeObject)
        createSyncJob(job, result)
    }

    private fun syncJobWithSyncDirection(args: Any?, result: MethodChannel.Result) {
        val data: Map<*, *> = Convert.Companion.toMap(
            args!!
        )
        val syncDirection: SyncGeodatabaseParameters.SyncDirection =
            Convert.Companion.toSyncDirection(
                data["syncDirection"]
            )
        val rollbackOnFailure: Boolean = Convert.Companion.toBoolean(
            data["rollbackOnFailure"]!!
        )
        val geodatabaseId = data["geodatabase"] as String?
        val geodatabase =
            nativeObjectStorage.getNativeObject(geodatabaseId) as GeodatabaseNativeObject
        val job =
            nativeObject.syncGeodatabase(syncDirection, rollbackOnFailure, geodatabase.nativeObject)
        createSyncJob(job, result)
    }

    private fun createSyncJob(job: SyncGeodatabaseJob, result: MethodChannel.Result) {
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = SyncGeodatabaseJobNativeObject(jobId, job)
        jobNativeObject.setMessageSink(messageSink)
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}