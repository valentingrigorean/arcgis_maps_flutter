package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncTask
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap.toOfflineMapSyncParametersOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.util.UUID

class OfflineMapSyncTaskNativeObject(
    objectId: String,
    task: OfflineMapSyncTask
) : BaseNativeObject<OfflineMapSyncTask>(
    objectId, task, arrayOf<NativeHandler>(
        LoadableNativeHandler(task),
    )
) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "offlineMapSyncTask#getUpdateCapabilities" -> {
                result.success(nativeObject.updateCapabilities?.toFlutterJson())
            }

            "offlineMapSyncTask#checkForUpdates" -> {
                scope.launch {
                    nativeObject.checkForUpdates().onSuccess {
                        result.success(it.toFlutterJson())
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            "offlineMapSyncTask#defaultOfflineMapSyncParameters" -> {
                scope.launch {
                    nativeObject.createDefaultOfflineMapSyncParameters().onSuccess {
                        result.success(it.toFlutterJson())
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            "offlineMapSyncTask#offlineMapSyncJob" -> {
                createJob(args as Map<*, *>, result)
            }

            else -> super.onMethodCall(method, args, result)
        }
    }

    private fun createJob(data: Map<*, *>, result: MethodChannel.Result) {
        val offlineMapSyncParameters = data.toOfflineMapSyncParametersOrNull()!!
        val offlineMapSyncJob = nativeObject.createOfflineMapSyncJob(offlineMapSyncParameters)
        val jobId = UUID.randomUUID().toString()
        val jobNativeObject = OfflineMapSyncJobNativeObject(jobId, offlineMapSyncJob)
        jobNativeObject.setMessageSink(getMessageSink())
        nativeObjectStorage.addNativeObject(jobNativeObject)
        result.success(jobId)
    }
}