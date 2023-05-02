package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.arcgismaps.tasks.geodatabase.GeodatabaseSyncTask
import com.arcgismaps.tasks.geodatabase.SyncGeodatabaseJob
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.toGenerateGeodatabaseParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.toSyncDirection
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.toSyncGeodatabaseParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.data.GeodatabaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.util.UUID

class GeodatabaseSyncTaskNativeObject(objectId: String, task: GeodatabaseSyncTask) :
    BaseNativeObject<GeodatabaseSyncTask>(
        objectId, task, arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
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
        scope.launch {
            val areaOfInterest = args!!.toGeometryOrNull()!!
            nativeObject.createDefaultGenerateGeodatabaseParameters(areaOfInterest).onSuccess {
                result.success(it.toFlutterJson())
            }.onFailure {
                result.success(it.toFlutterJson())
            }
        }
    }

    private fun importDelta(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val data = args as Map<*, *>
            val deltaFilePath = data["deltaFilePath"] as String
            val geodatabaseId = data["geodatabase"] as String
            val geodatabase =
                nativeObjectStorage.getNativeObject<GeodatabaseNativeObject>(geodatabaseId)
            GeodatabaseSyncTask.importDelta(geodatabase.nativeObject, deltaFilePath)
                .onSuccess { results ->
                    result.success(results.map { it.toFlutterJson() })
                }.onFailure {
                    result.success(it.toFlutterJson())
                }
        }
    }

    private fun generateJob(args: Any?, result: MethodChannel.Result) {
        val data = args as Map<*, *>
        val parameters = data["parameters"]?.toGenerateGeodatabaseParametersOrNull()!!
        val fileNameWithPath = data["fileNameWithPath"] as String
        val job = nativeObject.createGenerateGeodatabaseJob(parameters, fileNameWithPath)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = GenerateGeodatabaseJobNativeObject(jobId, job, getMessageSink())
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }

    private fun defaultSyncGeodatabaseParameters(args: Any?, result: MethodChannel.Result) {
        scope.launch {
            val geodatabaseId = args as String
            val geodatabase =
                nativeObjectStorage.getNativeObject<GeodatabaseNativeObject>(geodatabaseId)

            nativeObject.createDefaultSyncGeodatabaseParameters(geodatabase.nativeObject)
                .onSuccess {
                    result.success(it.toFlutterJson())
                }.onFailure {
                    result.success(it.toFlutterJson())
                }
        }
    }

    private fun syncJob(args: Any?, result: MethodChannel.Result) {
        val data = args as Map<*, *>
        val parameters = data["parameters"]?.toSyncGeodatabaseParametersOrNull()!!
        val geodatabaseId = data["geodatabase"] as String
        val geodatabase =
            nativeObjectStorage.getNativeObject<GeodatabaseNativeObject>(geodatabaseId)
        val job = nativeObject.createSyncGeodatabaseJob(parameters, geodatabase.nativeObject)
        createSyncJob(job, result)
    }

    private fun syncJobWithSyncDirection(args: Any?, result: MethodChannel.Result) {
        val data = args as Map<*, *>
        val syncDirection = (data["syncDirection"] as Int).toSyncDirection()
        val rollbackOnFailure = data["rollbackOnFailure"] as Boolean
        val geodatabaseId = data["geodatabase"] as String
        val geodatabase =
            nativeObjectStorage.getNativeObject<GeodatabaseNativeObject>(geodatabaseId)
        val job =
            nativeObject.createSyncGeodatabaseJob(syncDirection, rollbackOnFailure, geodatabase.nativeObject)
        createSyncJob(job, result)
    }

    private fun createSyncJob(job: SyncGeodatabaseJob, result: MethodChannel.Result) {
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = SyncGeodatabaseJobNativeObject(jobId, job)
        jobNativeObject.setMessageSink(getMessageSink())
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}