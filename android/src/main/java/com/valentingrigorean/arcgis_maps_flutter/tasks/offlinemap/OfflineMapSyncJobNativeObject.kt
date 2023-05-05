package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class OfflineMapSyncJobNativeObject(objectId: String, job: OfflineMapSyncJob) :
    BaseNativeObject<OfflineMapSyncJob>(
        objectId, job, arrayOf(
            JobNativeHandler(job),
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "offlineMapSyncJob#getGeodatabaseDeltaInfos" -> {
                val geodatabaseDeltaInfos = nativeObject.geodatabaseDeltaInfos.value
                result.success(geodatabaseDeltaInfos.map { it.toFlutterJson() })
            }

            "offlineMapSyncJob#getResult" -> {
                scope.launch {
                    nativeObject.result().onSuccess {
                        result.success(it.toFlutterJson())
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}